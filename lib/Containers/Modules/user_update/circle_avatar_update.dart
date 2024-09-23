import 'dart:convert';
import 'dart:io';

import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_storage/firebase_storage.dart'; // Importez cette bibliothèque
import 'package:image_picker/image_picker.dart'; // Importez cette bibliothèque
import 'package:flutter/material.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditAvatar extends StatefulWidget {
  const EditAvatar({Key? key}) : super(key: key);

  @override
  _EditAvatarState createState() => _EditAvatarState();
}

class _EditAvatarState extends State<EditAvatar> {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('user_token');

    try {
      final response =
          await http.put(Uri.parse('$routeAPI/api/users/me'), body: {
        'image_url': imageUrl,
      }, headers: {
        'Authorization': 'Bearer $userToken'
      });

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Si la requête réussit (statut 200), analyser la réponse JSON
        final data = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_token', data['accessToken']);
        final userService = Provider.of<UserService>(context, listen: false);
        userService.updateUser(data);

        NotificationService.showInfo(context, 'Mis à jour avec succès');
      } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        NotificationService.showError(context, 'Échec de la mise à jour $data');
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError(context, 'Erreur: $e');
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
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title:
                      Text(translateService.translate('PICTURE_FROM_CAMERA')),
                  onTap: () async {
                    await _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
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

    final fileName =
        'profile_image_${userID}.jpg';

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
    return Container(
      height: 150,
      width: double.infinity,
      color: Color(0xFF2CC394),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Stack(children: <Widget>[
                CircleAvatar(
                  backgroundImage: userUrl.isNotEmpty && _image == null
                      ? NetworkImage(userUrl)
                      : _image != null
                          ? FileImage(_image!) as ImageProvider<Object>
                          : null,
                  backgroundColor: Colors.blueGrey,
                  radius: 60.0,
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
                  top: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xFF102820),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.camera_alt_rounded,
                          size: 15, color: Colors.white),
                      onPressed: () async {
                        await _pickImage();
                        await _uploadImageToFirebase();
                      },
                    ),
                  ),
                ),
              ])),
          // const SizedBox(height: 10),
          // Center(
          //   child: ElevatedButton(
          //     onPressed: () async {
          //       await _pickImage();
          //       await _uploadImageToFirebase();
          //     },
          //     child: Text(translationService.translate('UPDATE_MY_PICTURE')),
          //   ),
          // ),
        ],
      ),
    );
  }
}
