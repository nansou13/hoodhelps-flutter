import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/template.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
    final translationService = context.read<TranslationService>();
    if (_codeController.text.isEmpty) {
      NotificationService.showError(
          context, translationService.translate("NOTIF_PLEASE_ENTER_CODE"));
      return;
    }
    if (_newPasswordController.text.isEmpty) {
      NotificationService.showError(
          context, translationService.translate("NOTIF_PLEASE_ENTER_PASSWORD"));
      return;
    }
    if (_newPassword2Controller.text.isEmpty) {
      NotificationService.showError(context,
          translationService.translate("NOTIF_PLEASE_ENTER_PASSWORD2"));
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
              .pushReplacementNamed(RouteConstants.forgotPasswordResetSuccess);
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
    final translationService = context.read<TranslationService>();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            translationService.translate("FORM_FORGOT_ACCOUNT_LINK"),
          ),
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
                          child: Column(
                            children: [
                              //add image
                              const Image(
                                image: AssetImage('assets/forgotPassword.jpg'),
                                // width: 100,
                              ),
                              const SizedBox(height: 10),

                              Text(
                                translationService
                                    .translate("RESET_CODE_DESCRIPTION"),
                                style: const TextStyle(fontSize: 15.0),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                      const SizedBox(height: 20.0),

                      TextField(
                        controller: _codeController,
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: translationService
                              .translate("HINT_TEXT_ENTER_CODE"),
                          hintStyle: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 20.0),

                      TextField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: translationService
                                .translate("LABEL_TEXT_PASSWORD")),
                      ),
                      const SizedBox(height: 20.0),

                      TextField(
                        controller: _newPassword2Controller,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: translationService
                                .translate("HINT_TEXT_ENTER_NEW_PASSWORD2")),
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
                          child: Text(
                            translationService.translate("UPDATE_PASSWORD"),
                            style: const TextStyle(
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
