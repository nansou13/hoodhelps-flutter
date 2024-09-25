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
      if (now - cacheTime <= const Duration(minutes: 10).inMilliseconds) {
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

  Future<void> cacheCategoryDataList(List<dynamic> data, groupeID) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setString(groupeID + '-list', jsonEncode(data));
    await prefs.setInt(cacheTimeKey, now);
  }

  Future<List<dynamic>> getCacheCategoryDataList(String groupId) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(groupId + '-list');
    final cacheTime = prefs.getInt(cacheTimeKey);

    if (cachedData != null && cacheTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - cacheTime <= const Duration(minutes: 10).inMilliseconds) {
        return jsonDecode(cachedData);
      }
    }

    try {
      final responseCategory =
          await http.get(Uri.parse('$routeAPI/api/categories/$groupId/users'));
      if (responseCategory.statusCode == 200) {
        final usersData = jsonDecode(responseCategory.body);
        var processedUsers = <String, Map<String, dynamic>>{};

        for (var user in usersData) {
          var userId = user['user_id'];
          var jobInfo = {
            'job_id': user['job_id'],
            'job_name': user['job_name'],
            'category_id': user['category_id'],
            'category_name': user['category_name']
          };

          if (!processedUsers.containsKey(userId)) {
            // Nouvel utilisateur, créez une entrée avec un tableau de métiers
            processedUsers[userId] = Map.from(user)..['jobs'] = [jobInfo];
          } else {
            // Utilisateur existant, ajoutez simplement le métier à son tableau
            processedUsers[userId]?['jobs'].add(jobInfo);
          }
        }

        var usersList = processedUsers.values.toList();
        
        await cacheCategoryDataList(usersList, groupId);
        return usersList;
      }
    } catch (e) {
      // Gérer l'erreur (peut-être renvoyer une liste vide ou envoyer l'erreur à un service de suivi)
      throw Exception("Une erreur s'est produite : ${e.toString()}");
    }

    return [];
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }
}