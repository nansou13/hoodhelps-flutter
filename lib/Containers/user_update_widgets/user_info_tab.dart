import 'dart:convert';

import 'package:hoodhelps/services/user_service.dart';
import 'package:hoodhelps/utils.dart';
import 'package:flutter/material.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditUserInfoPage extends StatefulWidget {
  const EditUserInfoPage({Key? key}) : super(key: key);

  @override
  _EditUserInfoPageState createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Map<String, dynamic> userInfo = {};
  bool isLoading = true;
  bool isMiniLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  Future<void> loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userToken = prefs.getString('user_token');

      if (userToken == null) {
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }

      final userService = Provider.of<UserService>(context, listen: false);
      var userData = userService.getUser();

        setState(() {
          userInfo = userData;
          isLoading = false;
          usernameController.text = userData['username'] ?? '';
          emailController.text = userData['email'] ?? '';
          firstNameController.text = userData['first_name'] ?? '';
          lastNameController.text = userData['last_name'] ?? '';
          phoneController.text = userData['phone_number'] ?? '';
        });
        return;
      
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError(context, "Erreur: ${e.toString()}");
    }
  }

  Future<void> updateUser() async {
    setState(() {
      isMiniLoading = true;
    });
    final firstname =
        FunctionUtils.capitalizeFirstLetter(firstNameController.text);
    final lastname =
        FunctionUtils.capitalizeFirstLetter(lastNameController.text);
    final phone = phoneController.text;
    final email = emailController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('user_token');

    try {
      final response =
          await http.put(Uri.parse('$routeAPI/api/users/me'), body: {
        'first_name': firstname,
        'last_name': lastname,
        'email': email,
        'phone_number': phone,
      }, headers: {
        'Authorization': 'Bearer $userToken'
      });

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Si la requête réussit (statut 200), analyser la réponse JSON
        final data = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_token', data['accessToken']);
        final userService = Provider.of<UserService>(context, listen: false);
        userService.updateUser(data);

        NotificationService.showInfo(context, 'Mis à jour avec succès');
      } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        NotificationService.showError(context, 'Échec de la mise à jour $data');
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError(context, 'Erreur: $e');
    }
    setState(() {
      isMiniLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Expanded(
                child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, 
        children: [
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, 
                children: [
                  TextField(
                    controller: usernameController,
                    enabled: false,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: firstNameController,
                    decoration: const InputDecoration(labelText: 'Prénom'),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: 'Nom'),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                ],
              )
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: MaterialButton(
            onPressed: () {
              if (!isMiniLoading) {
                updateUser();
              }
            },
            color: !isMiniLoading ? Colors.blue : Colors.grey,
            textColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
                width: double.infinity,
                height: 50.0,
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Enregistrer',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    isMiniLoading
                        ? const SizedBox(
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 3,
                              ),
                            ),
                            height: 20.0,
                            width: 20.0,
                          )
                        : const SizedBox(),
                  ],
                )),
          ),
          ),
          
          const SizedBox(height: 40.0),
        ],
      )
      );
    }
  }
}
