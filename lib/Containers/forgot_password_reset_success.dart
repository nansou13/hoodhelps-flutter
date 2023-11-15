import 'package:flutter/material.dart';
import 'package:hoodhelps/template.dart';

class ForgotPasswordResetSuccess extends StatelessWidget {
  const ForgotPasswordResetSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: null,
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
                                "Votre code a bien été modifié, vous pouvez retourner à l'écran de connexion.",
                                style: TextStyle(fontSize: 15.0),
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
                          child: const Text(
                            'Retour à la connexion',
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
