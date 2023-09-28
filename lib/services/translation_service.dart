import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class TranslationService {
  Map<String, dynamic> _translationMap = {};

  Future<void> loadTranslations(String locale) async {
    final String translationString =
        await rootBundle.loadString('assets/translations/$locale.json');
    _translationMap = json.decode(translationString);
  }

  String translate(String key) {
    return _translationMap[key] ?? key;
  }
}
