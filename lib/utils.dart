import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

// Constantes pour les clés SharedPreferences
const String userTokenKey = 'user_token';

class FunctionUtils {
  /// Déconnecte l'utilisateur et le redirige vers la page de connexion
  static Future<void> disconnectUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool success = await prefs.setString(userTokenKey, '');
    if (success) {
      Navigator.of(context, rootNavigator: true).pushReplacementNamed('/login');
    } else {
      // Gérez l'erreur comme vous le souhaitez, peut-être en affichant un message d'erreur
    }
  }
  
  /// Capitalise la première lettre d'une chaîne
  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}