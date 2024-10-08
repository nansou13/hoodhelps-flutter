import 'dart:convert';
import 'dart:io';

import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/services/api_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:hoodhelps/utils.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_storage/firebase_storage.dart'; // Importez cette bibliothèque
import 'package:image_picker/image_picker.dart'; // Importez cette bibliothèque
import 'package:flutter/material.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAvatar extends StatefulWidget {
  const EditAvatar({super.key});

  @override
  EditAvatarState createState() => EditAvatarState();
}

class EditAvatarState extends State<EditAvatar> {
  bool isMiniLoading = false;
  String imageUrl = '';
  File? _image;
  final picker = ImagePicker();
  final storageRef = FirebaseStorage.instance.ref();

  @override
  void initState() {
    super.initState();
  }

  Future<void> updateImage() async {
    try {
      final response = await ApiService().put(
        '/users/me',
        body: {
          'image_url': imageUrl,
        },
        useToken: true,
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Si la requête réussit (statut 200), analyser la réponse JSON
        final data = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_token', data['accessToken']);
        final userService = Provider.of<UserService>(navigatorKey.currentContext!, listen: false);
        userService.updateUser(data);

        NotificationService.showInfo( 'Mis à jour avec succès');
      } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        NotificationService.showError( 'Échec de la mise à jour $data');
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError( 'Erreur: $e');
    }
    setState(() {
      isMiniLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final translateService = context.read<TranslationService>();
    // Afficher un menu en bas de l'écran pour choisir la source de l'image
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: Text(
                        translateService.translate('PICTURE_FROM_GALLERY')),
                    onTap: () async {
                      await _getImage(ImageSource.gallery);
                      Navigator.of(navigatorKey.currentContext!).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title:
                      Text(translateService.translate('PICTURE_FROM_CAMERA')),
                  onTap: () async {
                    await _getImage(ImageSource.camera);
                    Navigator.of(navigatorKey.currentContext!).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        // Aucune image sélectionnée
      }
    });
  }

  Future<void> _uploadImageToFirebase() async {
    if (_image == null) {
      return;
    }
    setState(() {
      isMiniLoading = true;
    });
    final userService = Provider.of<UserService>(context, listen: false);
    var userData = userService.getUser();
    String? userID = userData['id'].toString();
    // Charger l'image dans un objet img.Image
    img.Image image = img.decodeImage(File(_image!.path).readAsBytesSync())!;

    // Redimensionner l'image
    img.Image resizedImg = img.copyResize(image,
        width: 500); // Vous pouvez également fixer la hauteur : height: 500

    // Obtenir l'image redimensionnée sous forme de liste d'uint8
    List<int> resizedBytes =
        img.encodeJpg(resizedImg, quality: 85); // 85 est la qualité de l'image

    // Créez un fichier à partir des octets redimensionnés
    File resizedFile = File(_image!.path)..writeAsBytesSync(resizedBytes);

    FirebaseStorage storage =
        FirebaseStorage.instanceFor(bucket: 'gs://hoodhelps.appspot.com');

    final fileName = 'profile_image_$userID.jpg';

    final profileImageRef = storage.ref().child('users').child(fileName);
    final uploadTask = profileImageRef.putFile(resizedFile);

    final taskSnapshot = await uploadTask.whenComplete(() {});
    imageUrl = await taskSnapshot.ref.getDownloadURL();

    await updateImage();
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);

    var userUrl = userService.imageUrl ?? '';
    var firstName = userService.firstName ?? '';
    var lastname = userService.lastName ?? '';
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Stack(children: <Widget>[
                CircleAvatar(
                  backgroundImage: userUrl.isNotEmpty && _image == null
                      ? NetworkImage(userUrl)
                      : _image != null
                          ? FileImage(_image!) as ImageProvider<Object>
                          : null,
                  backgroundColor: Colors.blueGrey,
                  radius: 50.0,
                  child: Text(
                    userUrl.isEmpty && _image == null
                        ? '${firstName.isNotEmpty ? firstName[0] : ''}${lastname.isNotEmpty ? lastname[0] : ''}'
                            .toUpperCase()
                        : '',
                    style: const TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: FigmaColors.primaryPrimary0,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit,
                          size: 15, color: FigmaColors.lightLight4),
                      onPressed: () async {
                        await _pickImage();
                        await _uploadImageToFirebase();
                      },
                    ),
                  ),
                ),
              ])),
        ],
      ),
    );
  }
}
