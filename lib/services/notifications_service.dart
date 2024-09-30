import 'package:flutter/material.dart';
import 'package:hoodhelps/utils.dart';

class NotificationService {
  static void showError(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5),
    );

    // Utilise le navigatorKey pour obtenir le BuildContext global
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
  }

  static void showInfo(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
    );

    // Utilise le navigatorKey pour obtenir le BuildContext global
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
  }
}
