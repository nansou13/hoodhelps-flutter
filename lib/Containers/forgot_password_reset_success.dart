import 'package:flutter/material.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/template.dart';
import 'package:provider/provider.dart';

class ForgotPasswordResetSuccess extends StatelessWidget {
  const ForgotPasswordResetSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    return Scaffold(
        appBar: AppBar(
          leading: null,
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
                                translationService.translate("UPDATE_PASSWORD_SUCCESS"),
                                style: const TextStyle(fontSize: 15.0),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                      const SizedBox(height: 20.0),
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/login');
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
                            translationService.translate("GO_TO_LOGIN"),
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
