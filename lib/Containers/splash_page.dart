import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/template.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hoodhelps/services/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('user_token');

    if (userToken == null) {
      _navigateToLogin();
      return;
    }

    // Appel API pour récupérer les données utilisateur
    final response = await http.get(
      Uri.parse('$routeAPI/api/users/me'),
      headers: {'Authorization': 'Bearer $userToken'},
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      final userService = Provider.of<UserService>(context, listen: false);
      userService.updateUser(userData);

      // Appel API pour récupérer les groupes
      final responseGroups = await http.get(
        Uri.parse('$routeAPI/api/users/groups'),
        headers: {'Authorization': 'Bearer $userToken'},
      );

      if (responseGroups.statusCode == 200) {
        final userGroupData = jsonDecode(responseGroups.body);
        userService.addUserGroups(userGroupData);

        if (userGroupData.isNotEmpty) {
          Navigator.of(context, rootNavigator: true).pushNamed(
            '/lobby',
            arguments: [userGroupData[0]['id']],
          );
        } else {
          Navigator.of(context).pushReplacementNamed(
            '/lobby',
            arguments: [],
          );
        }
      } else {
        _navigateToLogin();
      }
    } else {
      _navigateToLogin();
    }
  } catch (e) {
    NotificationService.showError(context, "Une erreur s'est produite : $e");
    _navigateToLogin();
  }
}

void _navigateToLogin() {
  Navigator.of(context).pushReplacementNamed('/login');
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      // Image de fond
      background(),
      Container(
        padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
        color: Colors.white.withOpacity(0.9),
        width: double.infinity,
        height: double.infinity,
        child: const Center(
          child:
              CircularProgressIndicator(), // Ou un autre widget de chargement
        ),
      ),
    ]));
  }
}
