import 'dart:convert';

import 'package:hoodhelps/Containers/Widgets/textfield_widget.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/api_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:hoodhelps/utils.dart';
import 'package:flutter/material.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUserInfoPage extends StatefulWidget {
  const EditUserInfoPage({super.key});

  @override
  EditUserInfoPageState createState() => EditUserInfoPageState();
}

class EditUserInfoPageState extends State<EditUserInfoPage> {
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
        Navigator.of(navigatorKey.currentContext!)
            .pushReplacementNamed(RouteConstants.registerLogin);
        return;
      }

      final userService = Provider.of<UserService>(navigatorKey.currentContext!, listen: false);
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
      NotificationService.showError( "Erreur: ${e.toString()}");
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

    try {
      final response = await ApiService().put('/users/me',
          useToken: true,
          body: {
            'first_name': firstname,
            'last_name': lastname,
            'email': email,
            'phone_number': phone,
          },
          context: context);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Si la requête réussit (statut 200), analyser la réponse JSON
        final data = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_token', data['accessToken']);
        final userService = Provider.of<UserService>(navigatorKey.currentContext!, listen: false);
        userService.updateUser(data);

        NotificationService.showInfo( 'Mis à jour avec succès');
      } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        NotificationService.showError( 'Échec de la mise à jour $data');
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError( 'Erreur: $e');
    }
    setState(() {
      isMiniLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
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
                    buildTextField(
                      controller: usernameController,
                      hintText:
                          translationService.translate('LABEL_TEXT_USERNAME'),
                      key: "usernameField",
                    ),
                    const SizedBox(height: 15.0),
                    buildTextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText:
                          translationService.translate('LABEL_TEXT_EMAIL'),
                      key: "emailField",
                    ),
                    const SizedBox(height: 15.0),
                    buildTextField(
                      controller: firstNameController,
                      hintText:
                          translationService.translate('LABEL_TEXT_FIRSTNAME'),
                      key: "firstNameField",
                    ),
                    const SizedBox(height: 15.0),
                    buildTextField(
                      controller: lastNameController,
                      hintText:
                          translationService.translate('LABEL_TEXT_LASTNAME'),
                      key: "lastNameField",
                    ),
                    const SizedBox(height: 15.0),
                    buildTextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      hintText:
                          translationService.translate('LABEL_TEXT_PHONE'),
                      key: "phoneNumberField",
                    ),
                  ],
                )),
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
              color: !isMiniLoading ? const Color(0xFF102820) : Colors.grey,
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
                      Text(
                        translationService.translate('SAVE_MY_DATA'),
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      isMiniLoading
                          ? const SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 3,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  )),
            ),
          ),
          const SizedBox(height: 40.0),
        ],
      ));
    }
  }
}
