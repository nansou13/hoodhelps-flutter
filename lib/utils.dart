import 'package:hoodhelps/route_constants.dart';
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
      Navigator.of(context, rootNavigator: true).pushReplacementNamed(RouteConstants.registerLogin);
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

  static String getUserName(Map<String, dynamic> user) {
    String firstName = user['first_name'] ?? '';
      String lastName = user['last_name'] ?? '';
      String username = user['username'] ?? '';

      if (firstName.isNotEmpty) {
        return '$firstName $lastName'; // Concatène le prénom et le nom
      } else {
        return username; // Utilise le username si pas de first_name
      }
  }

  static String formatPhoneNumber(String phoneNumber) {
  // Supprimez les espaces existants ou autres caractères non numériques
  phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

  // Utilisez une expression régulière pour ajouter un espace tous les deux chiffres
  return phoneNumber.replaceAllMapped(RegExp(r'(\d{2})(?=\d)'), (Match match) => '${match.group(1)} ');
}

}