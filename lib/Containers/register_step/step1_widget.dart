import 'package:flutter/material.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class Step1Widget extends StatefulWidget {
  final Function nextStepCallback; // Ajoutez ce paramètre

  const Step1Widget({Key? key, required this.nextStepCallback})
      : super(key: key);

  @override
  _Step1WidgetState createState() => _Step1WidgetState();
}

class _Step1WidgetState extends State<Step1Widget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonDisabled =
      true; // Variable pour contrôler la disponibilité du bouton

  @override
  void initState() {
    super.initState();
    // Écoutez les modifications dans les champs de texte pour mettre à jour l'état du bouton
    _usernameController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    // Assurez-vous de supprimer les écouteurs lors de la suppression du widget
    _usernameController.removeListener(_updateButtonState);
    _emailController.removeListener(_updateButtonState);
    _passwordController.removeListener(_updateButtonState);
    super.dispose();
  }

  void _updateButtonState() {
    // Vérifiez si tous les champs sont remplis
    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;

    setState(() {
      _isButtonDisabled = username.isEmpty || password.isEmpty || email.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(
              10.0), // Ajoute 8 points de marge intérieure
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //add image
              Image(
                image: AssetImage('assets/register.jpg'),
                // width: 100,
              ),
              SizedBox(height: 10),
              Text(
                'Étape 1',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                  'Pour commencer, veuillez saisir votre adresse e-mail, un nom d\'utilisateur et un mot de passe'),
              
            ],
          )),
        const SizedBox(height: 20.0),
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        const SizedBox(height: 10.0),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 10.0),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        const SizedBox(height: 20.0),
        MaterialButton(
          onPressed: _isButtonDisabled ? null : registerData,
          color: Colors.blue,
          disabledColor: Colors.grey,
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
        const SizedBox(height: 20.0),
        MaterialButton(
          onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
          color: Colors.white,
          textColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: double.infinity,
            height: 50.0,
            alignment: Alignment.center,
            child: const Text(
              'Retour à la connexion',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> registerData() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;

    if (!isEmailValid(email)) {
      NotificationService.showError(context, 'Adresse e-mail invalide');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$routeAPI/api/users/register'),
        body: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_token', data['accessToken']);
        prefs.setString('user_id', data['user']['id']);

        widget.nextStepCallback();
      } else {
        final errorData = jsonDecode(response.body);

        NotificationService.showError(context, "Échec de la création: ${errorData['message']}");
      }
    } catch (e) {
      setState(() {
        NotificationService.showError(context, "Erreur: $e");
      });
    }
  }
}

bool isEmailValid(String email) {
  // Expression régulière pour valider l'adresse e-mail
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return emailRegex.hasMatch(email);
}
