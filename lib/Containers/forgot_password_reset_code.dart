import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/textfield_widget.dart';
import 'package:hoodhelps/constants.dart';
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
  final TextEditingController _newPassword2Controller = TextEditingController();

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
    if (_newPassword2Controller.text.isEmpty) {
      NotificationService.showError(context,
          translationService.translate("NOTIF_PLEASE_ENTER_PASSWORD2"));
      return;
    }

    try {
      final response = await http
          .post(Uri.parse('$routeAPI/api/users/reset-password'), body: {
        'resetCode': _codeController.text,
        'newPassword': _newPasswordController.text,
        'newPassword2': _newPassword2Controller.text,
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2F2F2),
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleTextStyle: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          translationService.translate("FORM_FORGOT_ACCOUNT_LINK"),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Color(0xFFF2F2F2),
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
            child: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                  // Ajoutez le SingleChildScrollView ici
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(children: [
                              const Image(
                                image: AssetImage('assets/cuate.png'),
                                height: 200,
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                translationService
                                    .translate('RESET_CODE_DESCRIPTION'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Color(0xFF696969),
                                ),
                              ),
                            ]),
                            Column(children: [
                              buildTextField(
                                controller: _codeController,
                                hintText: translationService
                                    .translate('HINT_TEXT_ENTER_CODE'),
                                key: "codeLostPasswordField",
                              ),
                              const SizedBox(height: 20.0),
                              buildTextField(
                                controller: _newPasswordController,
                                hintText: translationService
                                    .translate('LABEL_TEXT_PASSWORD'),
                                key: "newPasswordField",
                                obscureText: true,
                              ),
                              const SizedBox(height: 20.0),
                              buildTextField(
                                controller: _newPassword2Controller,
                                hintText: translationService
                                    .translate('HINT_TEXT_ENTER_NEW_PASSWORD2'),
                                key: "newPasswordField2",
                                obscureText: true,
                              ),
                            ]),
                            MaterialButton(
                              onPressed: () {
                                updatePasswordWithCode();
                              },
                              color: Color(0xFF102820),
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
                                  translationService
                                      .translate("UPDATE_PASSWORD"),
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )));
            }),
          ),
        ],
      ),
    );
  }
}
