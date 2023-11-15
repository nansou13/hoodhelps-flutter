import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/template.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordResetCode extends StatefulWidget {
  const ForgotPasswordResetCode({Key? key}) : super(key: key);

  @override
  _ForgotPasswordResetCodeState createState() =>
      _ForgotPasswordResetCodeState();
}

class _ForgotPasswordResetCodeState extends State<ForgotPasswordResetCode> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPassword2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> updatePasswordWithCode() async {
    if (_codeController.text.isEmpty) {
      NotificationService.showError(context, "Veuillez saisir un code");
      return;
    }
    if (_newPasswordController.text.isEmpty) {
      NotificationService.showError(
          context, "Veuillez saisir un nouveau mot de passe");
      return;
    }
    if (_newPassword2Controller.text.isEmpty) {
      NotificationService.showError(
          context, "Veuillez saisir à nouveau votre nouveau mot de passe");
      return;
    }

    try {
      final response = await http
          .post(Uri.parse('$routeAPI/api/users/reset-password'), body: {
        'resetCode': _codeController.text,
        'newPassword': _newPasswordController.text,
        'newPassword2': _newPassword2Controller.text,
      });

      switch (response.statusCode) {
        case 200:
          Navigator.of(context)
              .pushReplacementNamed('/forgotpasswordresetsuccess');
          break;
        default:
          var result = json.decode(response.body);
          NotificationService.showError(context, result['error']);
      }
    } catch (e) {
      NotificationService.showError(context, "Erreur serveur. ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Mot de passe oublié ?'),
        ),
        body: Stack(
          children: [
            // Image de fond
            background(),

            Container(
              color: Colors.white.withOpacity(0.9),
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  // Ajout de SingleChildScrollView
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(
                              10.0), // Ajoute 8 points de marge intérieure
                          child: const Column(
                            children: [
                              //add image
                              Image(
                                image: AssetImage('assets/forgotPassword.jpg'),
                                // width: 100,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Entrez le code reçu via votre e-mail associée à votre compte dans le champ ci-dessous. Ainsi que votre nouveau mot de passe.",
                                style: TextStyle(fontSize: 15.0),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                      const SizedBox(height: 20.0),

                      TextField(
                        controller: _codeController,
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          hintText: 'Entrez le code',
                          hintStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 20.0),

                      TextField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Nouveau mot de passe'),
                      ),
                      const SizedBox(height: 20.0),

                      TextField(
                        controller: _newPassword2Controller,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Tappez à nouveau votre mot de passe'),
                      ),
                      const SizedBox(height: 40), // Ajoute un espacement
                      MaterialButton(
                        onPressed: () {
                          updatePasswordWithCode();
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
                            'Modifier mon mot de passe',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
