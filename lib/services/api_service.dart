

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = '$routeAPI/api';

  Future<http.Response> get(String endpoint,
      {Map<String, String>? headers,
      BuildContext? context,
      bool? useToken = false}) async {
    headers = headers ?? {};
    headers.putIfAbsent('Content-Type', () => 'application/json');

    if (useToken == true) {
      String? token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    final response =
        await http.get(Uri.parse('$_baseUrl$endpoint'), headers: headers);
    _checkForErrors(response);
    return response;
  }

  Future<http.Response> post(String endpoint,
      {Map<String, String>? headers,
      Object? body,
      BuildContext? context,
      bool useToken = false}) async {
    headers = headers ?? {};
    headers.putIfAbsent('Content-Type', () => 'application/json');

    if (useToken) {
      String? token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    _checkForErrors(response);
    return response;
  }

  Future<http.Response> put(String endpoint,
      {Map<String, String>? headers,
      Object? body,
      BuildContext? context,
      bool useToken = false}) async {
    // if (useToken == true) {
    //   String? token = await getToken();
    //   headers = (headers ?? {})
    //     ..addAll({
    //       'Authorization': 'Bearer $token',
    //     });
    // }
    headers = headers ?? {};
    headers.putIfAbsent('Content-Type', () => 'application/json');

    if (useToken) {
      String? token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    final response = await http.put(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    _checkForErrors(response);
    return response;
  }

  Future<http.Response> delete(String endpoint,
      {Map<String, String>? headers,
      BuildContext? context,
      bool? useToken = false}) async {
    headers = headers ?? {};
    headers.putIfAbsent('Content-Type', () => 'application/json');

    if (useToken == true) {
      String? token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    final response = await http.delete(
      Uri.parse('$_baseUrl$endpoint'),
      headers: headers,
    );
    _checkForErrors(response);
    return response;
  }

  Future<void> _checkForErrors(
      http.Response response) async {
        final context = navigatorKey.currentContext;
    if (response.statusCode == 401) {
      if (context != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, RouteConstants.registerLogin);
        });
      }
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('user_token');
    return userToken;
  }
}
