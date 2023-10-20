import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:firebase_storage/firebase_storage.dart'; // Importez cette bibliothèque
import 'package:image_picker/image_picker.dart'; // Importez cette bibliothèque
import 'package:flutter/material.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:intl/intl.dart';
import 'package:hoodhelps/utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class Step2Widget extends StatefulWidget {
  final Function nextStepCallback; // Ajoutez ce paramètre

  const Step2Widget({Key? key, required this.nextStepCallback}) : super(key: key);

  @override
  _Step2WidgetState createState() => _Step2WidgetState();
}

class _Step2WidgetState extends State<Step2Widget> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String imageUrl = '';

  File? _image;
  final picker = ImagePicker();
  final storageRef = FirebaseStorage.instance.ref();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        // no image selected
      }
    });
  }

  Future<void> _uploadImageToFirebase() async {
    if (_image == null) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('user_id');

    // Charger l'image dans un objet img.Image
    img.Image image = img.decodeImage(File(_image!.path).readAsBytesSync())!;
    
    // Redimensionner l'image
    img.Image resizedImg = img.copyResize(image, width: 500); // Vous pouvez également fixer la hauteur : height: 500

    // Obtenir l'image redimensionnée sous forme de liste d'uint8
    List<int> resizedBytes = img.encodeJpg(resizedImg, quality: 85); // 85 est la qualité de l'image
    
    // Créez un fichier à partir des octets redimensionnés
    File resizedFile = File(_image!.path)..writeAsBytesSync(resizedBytes);

    FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://hoodhelps.appspot.com');

    final fileName = 'profile_image_${userID ?? DateTime.now().millisecondsSinceEpoch}.jpg';
    
    final profileImageRef = storage.ref().child('users').child(fileName);
    final uploadTask = profileImageRef.putFile(resizedFile);

    final taskSnapshot = await uploadTask.whenComplete(() {});
    imageUrl = await taskSnapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Étape 2',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        const Text('Veuillez fournir vos informations personnelles pour créer votre compte.'),
        const SizedBox(height: 20.0),
        Center(
          child: CircleAvatar(
          radius: 50,
          backgroundImage: _image != null ? FileImage(_image!) : null,
          child: _image == null ? Icon(Icons.person, size: 50) : null,
        ),
        ),
        
        Center(
          child: 
          ElevatedButton(
          onPressed: () async {
            await _pickImage();
            await _uploadImageToFirebase();
          },
          child: Text("Choisir une photo"),
        ),
        ),
        const SizedBox(height: 10.0),
        
        TextField(
          controller: firstNameController,
          decoration: const InputDecoration(labelText: 'Prénom'),
        ),
        const SizedBox(height: 10.0),
        TextField(
          controller: lastNameController,
          decoration: const InputDecoration(labelText: 'Nom'),
        ),
        const SizedBox(height: 10.0),
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(labelText: 'Phone'),
        ),
        const SizedBox(height: 20.0),
        MaterialButton(
          onPressed: () {
            saveUserInfoData();
          },
          color: Colors.blue,
          textColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: double.infinity,
            height: 50.0,
            alignment: Alignment.center,
            child: const Text(
              'Inscription',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> saveUserInfoData() async {
    final firstname = FunctionUtils.capitalizeFirstLetter(firstNameController.text);
    final lastname = FunctionUtils.capitalizeFirstLetter(lastNameController.text);
    final phone = phoneController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('user_token');

    try {
      final response = await http
          .put(Uri.parse('$routeAPI/api/users/me'), body: {
        'first_name': firstname,
        'last_name': lastname,
        'phone_number': phone,
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
        
        widget.nextStepCallback();
      } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        NotificationService.showError(context, 'Échec de la mise à jour $data');
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError(context, 'Erreur: $e');
    }
  }
}

String formatDate(String inputDate) {
  // Créez un analyseur de dates pour le format d'entrée "dd/MM/yyyy"
  final inputFormat = DateFormat('dd/MM/yyyy');

  // Parsez la date d'entrée en objet DateTime
  final date = inputFormat.parse(inputDate);

  // Créez un formateur de dates pour le format de sortie "yyyy-MM-dd"
  final outputFormat = DateFormat('yyyy-MM-dd');

  // Formatez la date dans le format de sortie
  final formattedDate = outputFormat.format(date);

  return formattedDate;
}