import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoodhelps/constants.dart';
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('user_token');

    if (userToken == null) Navigator.of(context).pushReplacementNamed('/login');

    // Appel API
    final response = await http.get(Uri.parse('$routeAPI/api/users/me'),
        headers: {'Authorization': 'Bearer $userToken'});

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      // Mettez à jour _user avec les données récupérées
      final userService = Provider.of<UserService>(context, listen: false);
      userService.updateUser(userData);

      // Appel API des groupes
      var userGroupData = [];
      final responseGroups = await http.get(
          Uri.parse('$routeAPI/api/users/groups'),
          headers: {'Authorization': 'Bearer $userToken'});
      if (responseGroups.statusCode == 200) {
        userGroupData = jsonDecode(responseGroups.body);
        userService.addUserGroups(userGroupData);
      }
      if (userGroupData.isNotEmpty) {
        Navigator.of(context, rootNavigator: true).pushNamed(
          '/lobby',
          arguments: userGroupData[0]['id'],
        );
      } else {
        Navigator.of(context).pushReplacementNamed('/lobby');
      }
      // isLoading = false;
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      // Image de fond
      Image.asset(
        'assets/background_image.jpg', // Remplacez par le chemin de votre image de fond
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),

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
