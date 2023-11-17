import 'package:flutter/material.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/template.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _mailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> sendMailForgotAccount() async {
    final userEmail = _mailController.text.toLowerCase();
    final translationService = context.read<TranslationService>();

    if (userEmail.isEmpty) {
      NotificationService.showError(
          context, translationService.translate("NOTIF_PLEASE_ENTER_EMAIL"));
      return;
    }
    try {
      final response = await http
          .post(Uri.parse('$routeAPI/api/users/request-password-reset'), body: {
        'email': userEmail,
      });
      switch (response.statusCode) {
        case 200:
          Navigator.of(context, rootNavigator: true)
              .pushNamed(RouteConstants.forgotPasswordResetCode);
          break;
        case 404:
          NotificationService.showError(context, response.body);
          break;
        default:
          NotificationService.showError(
              context, 'Erreur serveur. ${response.body}');
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
          title: Text(translationService.translate("FORM_FORGOT_ACCOUNT_LINK")),
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
                                    .translate("FORGOT_PASSWORD_DESCRIPTION"),
                                style: const TextStyle(fontSize: 15.0),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                      const SizedBox(height: 20.0),

                      TextField(
                        controller: _mailController,
                        decoration: InputDecoration(labelText: translationService.translate("LABEL_TEXT_EMAIL")),
                      ),
                      const SizedBox(height: 40), // Ajoute un espacement
                      MaterialButton(
                        onPressed: () {
                          sendMailForgotAccount();
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
                            translationService.translate("SEND_THE_CODE"),
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(RouteConstants.forgotPasswordResetCode);
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
                          child: Text(
                            translationService.translate("ALREADY_HAVE_A_CODE"),
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
