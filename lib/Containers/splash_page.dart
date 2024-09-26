import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/api_service.dart';
import 'package:hoodhelps/services/jobs_provider.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
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
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final jobsProvider = Provider.of<JobsProvider>(context, listen: false);
      await jobsProvider.fetchJobs();

      final userToken = await ApiService().getToken();

      if (userToken == null) {
        _navigateToLogin();
        return;
      }

      await _fetchUserData();
    } catch (e) {
      NotificationService.showError(context, "Une erreur s'est produite : $e");
      _navigateToLogin();
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final userResponse = await _getUserData();
      if (userResponse.statusCode == 200) {
        final userData = jsonDecode(userResponse.body);
        final userService = Provider.of<UserService>(context, listen: false);
        userService.updateUser(userData);

        await _fetchUserGroups(userService);
        await _fetchUserJobs(userService);

        _navigateToLobby();
      } else {
        _navigateToLogin();
      }
    } catch (e) {
      throw Exception("Erreur lors du chargement des données utilisateur");
    }
  }

  Future<http.Response> _getUserData() {
    return ApiService().get('/users/me', useToken: true, context: context);
  }

  Future<void> _fetchUserGroups(UserService userService) async {
    final responseGroups = await ApiService().get(
      '/users/groups',
      useToken: true,
      context: context,
    );

    if (responseGroups.statusCode == 200) {
      final userGroupData = jsonDecode(responseGroups.body);
      userService.addUserGroups(userGroupData);

      if (userGroupData.isNotEmpty) {
        userService.setCurrentGroupId(userGroupData[0]['id']);
      }
    } else {
      throw Exception("Erreur lors du chargement des groupes");
    }
  }

  Future<void> _fetchUserJobs(UserService userService) async {
    final responseJob = await ApiService()
        .get('/users/me/job', useToken: true, context: context);

    if (responseJob.statusCode == 200) {
      final userJobData = jsonDecode(responseJob.body);
      userService.addUserJobs(userJobData);
    } else {
      throw Exception("Erreur lors du chargement des groupes");
    }
  }

  void _navigateToLogin() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.of(context).pushReplacementNamed(RouteConstants.registerLogin);
  });
}

void _navigateToLobby() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.of(context).pushReplacementNamed(RouteConstants.lobby);
  });
}

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
          padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
          color: Colors.white.withOpacity(0.9),
          width: double.infinity,
          height: double.infinity,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image de l'application
                Image(
                  image: AssetImage('assets/icon.png'),
                  width: 250.0,
                ),
                SizedBox(height: 20.0),
                // Texte de chargement
                CircularProgressIndicator(),
              ],
            ),
          )
          // Ou un autre widget de chargement
          ),
    ]));
  }
}
