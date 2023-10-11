import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class FunctionUtils {
  static Future<void> disconnectUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_token', '');
    Navigator.of(context, rootNavigator: true).pushReplacementNamed('/login');
  }

  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}