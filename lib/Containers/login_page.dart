import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/button_widget.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/Containers/Widgets/textfield_widget.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/api_service.dart';
import 'package:hoodhelps/services/firebase_messaging_service.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      // Initialisez le service FCM
      var firebaseMessagingService = FirebaseMessagingService();
      String? fcmToken = await firebaseMessagingService.getToken();

      final response = await ApiService().post('/users/login', body: {
        'username': _usernameController.text,
        'password': _passwordController.text,
        'token_notification': fcmToken,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user_token', data['accessToken']);
        Navigator.of(context).pushReplacementNamed(RouteConstants.splash);
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
    return TemplateTwoBlocks(
      appTitle: translationService.translate("APP_LOGIN_TITLE"),
      middleChild: loginForm(translationService),
      bottomChild: buildConnectButton(translationService),
    );
  }

  Widget loginForm(TranslationService translationService) {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        buildTextField(
          controller: _usernameController,
          labelText: translationService.translate("FORM_USERNAME"),
          hintText: translationService.translate("FORM_USERNAME"),
          key: 'usernameField',
        ),
        const SizedBox(height: 10.0),
        buildTextField(
          controller: _passwordController,
          labelText: translationService.translate("FORM_PASSWORD"),
          hintText: translationService.translate("FORM_PASSWORD"),
          key: 'passwordField',
          obscureText: true,
        ),
        const SizedBox(height: 4.0),
        forgotAccountLink(translationService),
      ],
    );
  }

  MaterialButton buildConnectButton(TranslationService translationService) {
    return buildButton(
      onPressed: fetchLoginData,
      text: translationService.translate("FORM_LOGIN_ACCOUNT_LINK"),
    );
  }

  InkWell forgotAccountLink(TranslationService translationService) {
    return InkWell(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RouteConstants.forgotPassword);
        },
        child: Align(
          alignment: Alignment.centerLeft, // Aligne le texte à gauche
          child: Text(
            translationService.translate("FORM_FORGOT_ACCOUNT_LINK"),
            style: FigmaTextStyles().stylizedSmall.copyWith(
                  color: FigmaColors.primaryPrimary1,
                  decoration:
                      TextDecoration.underline, // Ajouter le soulignement
                ),
          ),
        ),
      ),
    );
  }
}
