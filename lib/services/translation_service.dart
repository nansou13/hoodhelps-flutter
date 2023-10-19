import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class TranslationService {
  late Map<String, dynamic> _translationMap;

  Future<void> loadTranslations(String locale) async {
    try {
      final String translationString =
          await rootBundle.loadString('assets/translations/$locale.json');
      _translationMap = json.decode(translationString);
    } catch (e) {
      // Gérer l'exception, par exemple, en enregistrant une erreur ou en affichant un message à l'utilisateur
      throw Exception('Error loading translation: $e');
    }
  }

  String translate(String key) {
    return _translationMap[key] ?? key;
  }
}
