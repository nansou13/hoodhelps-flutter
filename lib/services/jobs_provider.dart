import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoodhelps/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const String jobsCacheKey = 'jobs_cache';
const String jobsCacheTimeKey = 'jobs_cache_time';
const Duration cacheDuration = Duration(minutes: 30);

class JobsProvider extends ChangeNotifier {
  List<dynamic> _jobs = [];
  List<dynamic> get jobs => _jobs;

  Future<void> fetchJobs() async {
    try {
      // Récupération du cache
      final cachedJobs = await _getJobsFromCache();
      if (cachedJobs != null) {
        _jobs = cachedJobs;
        notifyListeners();
      }

      // Si aucun cache ou si cache expiré, on fait l'appel API
      final isCacheValid = await _isCacheValid();
      if (!isCacheValid || _jobs.isEmpty) {
        final jobsFromApi = await _fetchJobsFromApi();
        if (jobsFromApi != null) {
          _jobs = jobsFromApi;
          await _cacheJobs(jobsFromApi);
          notifyListeners();
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des jobs: $e');
    }
  }

  Future<List<dynamic>?> _fetchJobsFromApi() async {
    try {
      final response =
          await http.get(Uri.parse('$routeAPI/api/categories/jobs'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception(
            'Erreur API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des jobs: $e');
    }
  }

  Future<void> _cacheJobs(List<dynamic> jobs) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setString(jobsCacheKey, jsonEncode(jobs));
    await prefs.setInt(jobsCacheTimeKey, now);
  }

  Future<List<dynamic>?> _getJobsFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(jobsCacheKey);
    if (cachedData != null) {
      return jsonDecode(cachedData);
    }
    return null;
  }

  Future<bool> _isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheTime = prefs.getInt(jobsCacheTimeKey);
    if (cacheTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return (now - cacheTime) <= cacheDuration.inMilliseconds;
    }
    return false;
  }
}
