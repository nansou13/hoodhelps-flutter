import 'dart:convert';
import 'package:hoodhelps/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CategoriesService {
  List categoryData = [];

  Future<void> cacheCategoryData(List data) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setString('categoryData', jsonEncode(data));
    await prefs.setInt('cacheTime', now);
  }

  Future<List> getCacheCategoryData(String groupId) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('categoryData');
    final cacheTime = prefs.getInt('cacheTime');

    if (cachedData != null && cacheTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - cacheTime <= const Duration(seconds: 10).inMilliseconds) {
        // Les données sont valides
        return jsonDecode(cachedData);
      }
    }
    // call API to get fresh data and cache it for next time
    final responseCategory =
        await http.get(Uri.parse('$routeAPI/api/categories/group/$groupId'));
    if (responseCategory.statusCode == 200) {
      final data = jsonDecode(responseCategory.body);
      await cacheCategoryData(data); // Mettre en cache les données fraîches
      return data; // Aucune donnée en cache ou données périmées
    }

    return []; // Aucune donnée en cache ou données périmées
  }
}
