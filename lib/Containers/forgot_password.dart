import 'package:flutter/material.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/template.dart';
import 'package:http/http.dart' as http;

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

    if (userEmail.isEmpty) {
      NotificationService.showError(context, "Veuillez saisir votre email");
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
              .pushNamed('/forgotpasswordresetcode');
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
                                "Vous avez oublié votre mot de passe ? Pas de souci, nous sommes là pour vous aider. Entrez l'adresse e-mail associée à votre compte dans le champ ci-dessous.",
                                style: TextStyle(fontSize: 15.0),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                      const SizedBox(height: 20.0),

                      TextField(
                        controller: _mailController,
                        decoration: const InputDecoration(labelText: 'Email'),
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
                          child: const Text(
                            'Envoyer le code',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed('/forgotpasswordresetcode');
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
                            "J'ai déjà un code",
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
