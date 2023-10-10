import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // bool _isLoading = false;

  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Au chargement de la page, récupérez le token depuis les préférences partagées
  }

  Future<void> fetchLoginData() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('$routeAPI/api/users/login'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Si la requête réussit (statut 200), analyser la réponse JSON
        final data = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_token', data['accessToken']);

        // Récupérez le token depuis les préférences partagées
        String? userToken = prefs.getString('user_token');

        // Vérifiez si le token existe
        if (userToken != null) {
          // Faites quelque chose avec le token (par exemple, utilisez-le pour l'authentification)
        } else {
          // Le token n'existe pas dans les préférences partagées
        }

        Navigator.of(context).pushReplacementNamed('/splash');
      } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        setState(() {
          _errorMessage = 'Échec de la connexion';
        });
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      setState(() {
        _errorMessage = 'Erreur: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Image.asset(
            'assets/background_image.jpg', // Remplacez par le chemin de votre image de fond
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Contenu en haut (titre et phrase)
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom de l'application
                Text(
                  translationService.translate("APP_TITLE"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                // Phrase
                Text(
                  translationService.translate("APP_TITLE_DESC"),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          // Contenu en bas (bloc de connexion)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              color: Colors.black.withOpacity(0.8),
              width: double.infinity,
              height: MediaQuery.of(context).size.height *
                  0.4, // La moitié de l'écran
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // Champs de texte (username et mot de passe)
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: translationService.translate("FORM_USERNAME"),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: translationService.translate("FORM_PASSWORD"),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    obscureText: true, // Pour masquer le mot de passe
                  ),
                  const SizedBox(height: 10.0),
                  // Bouton Connect personnalisé
                  MaterialButton(
                    onPressed: () {
                      fetchLoginData();
                    },
                    color: Colors.blue, // Couleur du bouton
                    textColor: Colors.white, // Couleur du texte du bouton
                    elevation: 0, // Supprime l'ombre du bouton
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // BorderRadius identique aux champs de texte
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 50.0, // Hauteur du bouton
                      alignment: Alignment.center,
                      child: Text(
                        translationService.translate("FORM_CONNECT_BUTTON"),
                        style: const TextStyle(
                          fontSize: 18.0, // Taille de police du texte du bouton
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: Text(
                        translationService
                            .translate("FORM_CREATE_ACCOUNT_LINK"),
                        style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
