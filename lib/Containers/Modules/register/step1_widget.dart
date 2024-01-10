import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/textfield_widget.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

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
    final translationService = context.read<TranslationService>();
    return 
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(child: const Image(
            image: AssetImage('assets/amico.png'),
            height: 100,
          )),
        
          const SizedBox(height: 5),
        Column(children: [
       
          Text(
            translationService.translate('STEP1_TITLE'),
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF50B498),
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            translationService.translate('STEP1_DESCRIPTION'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15.0,
              color: Color(0xFF696969),
            ),
          )
        ]),
        Column(children: [
          const SizedBox(height: 20.0),
          buildTextField(
            controller: _usernameController,
            hintText: translationService.translate('LABEL_TEXT_USERNAME'),
            key: "usernameField",
          ),
          const SizedBox(height: 10.0),
          buildTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: translationService.translate('LABEL_TEXT_EMAIL'),
            key: "emailField",
          ),
          const SizedBox(height: 10.0),
          buildTextField(
            controller: _passwordController,
            obscureText: true,
            hintText: translationService.translate('LABEL_TEXT_PASS'),
            key: "passwordField",
          ),
        ]),
        Column(
          children: [
            const SizedBox(height: 20.0),
            MaterialButton(
              onPressed: _isButtonDisabled ? null : registerData,
              color: Color(0xFF102820),
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
                child: Text(
                  translationService.translate('CREATE_ACCOUNT_BUTTON'),
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
              // color: Colors.white,
              //border color
              
              textColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: Color(0xFF102820)),
              ),
              child: Container(
                width: double.infinity,
                height: 50.0,
                alignment: Alignment.center,
                child: Text(
                  translationService.translate('GO_TO_LOGIN'),
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )
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

        NotificationService.showError(
            context, "Échec de la création: ${errorData['message']}");
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
