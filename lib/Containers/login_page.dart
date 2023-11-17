import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/template.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchLoginData() async {
    try {
      final response = await http.post(
        Uri.parse('$routeAPI/api/users/login'),
        body: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user_token', data['accessToken']);
        Navigator.of(context).pushReplacementNamed('/splash');
      } else {
        NotificationService.showError(context, "Échec de la connexion");
      }
    } catch (e) {
      NotificationService.showError(context, "Erreur: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    return Scaffold(
      body: Stack(
        children: [
          background(),
          appTitle(translationService),
          loginForm(translationService),
        ],
      ),
    );
  }

  Widget appTitle(TranslationService translationService) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30.0),
          const SizedBox(
            height: 300.0,
            child: Image(
              image: AssetImage('assets/icon.png'),
              // width: 100,
            ),
          ),
          Text(
            translationService.translate("APP_TITLE_DESC"),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget loginForm(TranslationService translationService) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        color: Colors.black.withOpacity(0.8),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            buildTextField(
              controller: _usernameController,
              hintText: translationService.translate("FORM_USERNAME"),
            ),
            const SizedBox(height: 10.0),
            buildTextField(
              controller: _passwordController,
              hintText: translationService.translate("FORM_PASSWORD"),
              obscureText: true,
            ),
            const SizedBox(height: 10.0),
            buildConnectButton(translationService),
            const SizedBox(height: 10.0),
            buildRegisterButton(translationService),
            const SizedBox(height: 10.0),
            forgotAccountLink(translationService),
          ],
        ),
      ),
    );
  }

  TextField buildTextField(
      {required TextEditingController controller,
      required String hintText,
      bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      obscureText: obscureText,
    );
  }

  MaterialButton buildConnectButton(TranslationService translationService) {
    return MaterialButton(
      onPressed: fetchLoginData,
      color: Colors.blue,
      textColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: double.infinity,
        height: 50.0,
        alignment: Alignment.center,
        child: Text(
          translationService.translate("FORM_CONNECT_BUTTON"),
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  MaterialButton buildRegisterButton(TranslationService translationService) {
    return MaterialButton(
      onPressed: () {
        Navigator.pushNamed(context, "/register");
      },
      color: Colors.white,
      textColor: Colors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: double.infinity,
        height: 50.0,
        alignment: Alignment.center,
        child: Text(
          translationService.translate("FORM_CREATE_ACCOUNT_LINK"),
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  InkWell forgotAccountLink(TranslationService translationService) {
    return InkWell(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/forgotpassword");
        },
        child: Text(
          translationService.translate("FORM_FORGOT_ACCOUNT_LINK"),
          style: const TextStyle(
            color: Colors.white,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
