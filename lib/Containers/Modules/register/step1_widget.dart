

import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Modules/register/progress_bar_widget.dart';
import 'package:hoodhelps/Containers/Widgets/button_widget.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/Containers/Widgets/textfield_widget.dart';
import 'package:hoodhelps/services/api_service.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'dart:convert';
import 'dart:core';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Step1Widget extends StatefulWidget {
  final Function nextStepCallback; // Ajoutez ce paramètre

  const Step1Widget({super.key, required this.nextStepCallback});

  @override
  Step1WidgetState createState() => Step1WidgetState();
}

class Step1WidgetState extends State<Step1Widget> {
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
    return genericSafeAreaTwoBlocks(
        middleChild: Column(children: [
          const ProgressBarWithCounter(currentStep: 1, totalSteps: 4),
          const SizedBox(height: 30.0),
          buildTextField(
            controller: _usernameController,
            hintText: translationService.translate('LABEL_TEXT_USERNAME'),
            labelText: translationService.translate('LABEL_TEXT_USERNAME'),
            key: "usernameField",
          ),
          const SizedBox(height: 10.0),
          buildTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: translationService.translate('PLACEHOLDER_TEXT_EMAIL'),
            labelText: translationService.translate('LABEL_TEXT_EMAIL'),
            key: "emailField",
          ),
          const SizedBox(height: 10.0),
          buildTextField(
            controller: _passwordController,
            obscureText: true,
            hintText: translationService.translate('PLACEHOLDER_TEXT_PASS'),
            labelText: translationService.translate('LABEL_TEXT_PASS'),
            key: "passwordField",
          ),
        ]),
        bottomChild: Column(
          children: [
            buildButton(
              onPressed: _isButtonDisabled ? null : registerData,
              text: translationService.translate('CREATE_ACCOUNT_BUTTON'),
            ),
          ],
        ));
  }

  Future<void> registerData() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;

    if (!isEmailValid(email)) {
      NotificationService.showError( 'Adresse e-mail invalide');
      return;
    }

    try {
      final response = await ApiService().post('/users/register', body: {
        'username': username,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_token', data['accessToken']);
        prefs.setString('user_id', data['user']['id']);

        widget.nextStepCallback();
      } else {
        final errorData = jsonDecode(response.body);

        NotificationService.showError(
            "Échec de la création: ${errorData['error']}");
      }
    } catch (e) {
      setState(() {
        NotificationService.showError( "Erreur: $e");
      });
    }
  }
}

bool isEmailValid(String email) {
  // Expression régulière pour valider l'adresse e-mail
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return emailRegex.hasMatch(email);
}
