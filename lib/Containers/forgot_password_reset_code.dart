import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/button_widget.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/Containers/Widgets/textfield_widget.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ForgotPasswordResetCode extends StatefulWidget {
  const ForgotPasswordResetCode({Key? key}) : super(key: key);

  @override
  _ForgotPasswordResetCodeState createState() =>
      _ForgotPasswordResetCodeState();
}

class _ForgotPasswordResetCodeState extends State<ForgotPasswordResetCode> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> updatePasswordWithCode() async {
    final translationService = context.read<TranslationService>();
    if (_codeController.text.isEmpty) {
      NotificationService.showError(
          context, translationService.translate("NOTIF_PLEASE_ENTER_CODE"));
      return;
    }
    if (_newPasswordController.text.isEmpty) {
      NotificationService.showError(
          context, translationService.translate("NOTIF_PLEASE_ENTER_PASSWORD"));
      return;
    }

    try {
      final response = await http
          .post(Uri.parse('$routeAPI/api/users/reset-password'), body: {
        'resetCode': _codeController.text,
        'newPassword': _newPasswordController.text,
        'newPassword2': _newPasswordController.text,
      });

      switch (response.statusCode) {
        case 200:
          Navigator.of(context)
              .pushReplacementNamed(RouteConstants.forgotPasswordResetSuccess);
          break;
        default:
          var result = json.decode(response.body);
          NotificationService.showError(context, result['error']);
      }
    } catch (e) {
      NotificationService.showError(context, "Erreur serveur. ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    return TemplateTwoBlocks(
      appTitle: translationService.translate("FORM_FORGOT_ACCOUNT_LINK"),
      middleChild: Column(children: [
              Text(
                translationService.translate('RESET_CODE_DESCRIPTION'),
                style: FigmaTextStyles().body16pt.copyWith(
                      color: FigmaColors.darkDark0,
                    ),
              ),
              const SizedBox(height: 32.0),
              buildTextField(
                controller: _codeController,
                labelText: translationService.translate('HINT_TEXT_ENTER_CODE'),
                hintText: translationService.translate('HINT_TEXT_ENTER_CODE'),
                key: "codeLostPasswordField",
              ),
              const SizedBox(height: 20.0),
              buildTextField(
                controller: _newPasswordController,
                labelText: translationService.translate('LABEL_TEXT_PASSWORD'),
                hintText: translationService.translate('PLACEHOLDER_TEXT_PASS'),
                key: "newPasswordField",
                obscureText: true,
              ),
            ]),
      bottomChild: Padding(padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0), 
            child: buildButton(
                onPressed: () {
                  updatePasswordWithCode();
                },
                text: translationService.translate("UPDATE_PASSWORD")),
            ),
    );
    
    
    
    
  }

  // Widget checkPasswordMandatory({required Function() onPressed, required String text}) {
  //   return 
  // }
}
