import 'dart:convert';
import 'package:hoodhelps/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const String categoryDataKey = 'categoryData';
const String cacheTimeKey = 'cacheTime';

class CategoriesService {
  List<dynamic> categoryData = [];

  Future<void> cacheCategoryData(List<dynamic> data, groupeID) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setString(groupeID, jsonEncode(data));
    await prefs.setInt(cacheTimeKey, now);
  }

  Future<List<dynamic>> getCacheCategoryData(String groupId) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(groupId);
    final cacheTime = prefs.getInt(cacheTimeKey);

    if (cachedData != null && cacheTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - cacheTime <= const Duration(seconds: 10).inMilliseconds) {
        return jsonDecode(cachedData);
      }
    }

    try {
      final responseCategory =
          await http.get(Uri.parse('$routeAPI/api/categories/group/$groupId'));
      if (responseCategory.statusCode == 200) {
        final data = jsonDecode(responseCategory.body);
        await cacheCategoryData(data, groupId);
        return data;
      }
    } catch (e) {
      // Gérer l'erreur (peut-être renvoyer une liste vide ou envoyer l'erreur à un service de suivi)
      throw Exception("Une erreur s'est produite : ${e.toString()}");
    }

    return []; 
  }
}
