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

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _mailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> sendMailForgotAccount() async {
    final userEmail = _mailController.text.toLowerCase();
    final translationService = context.read<TranslationService>();

    if (userEmail.isEmpty) {
      NotificationService.showError(
          context, translationService.translate("NOTIF_PLEASE_ENTER_EMAIL"));
      return;
    }
    try {
      final response = await http
          .post(Uri.parse('$routeAPI/api/users/request-password-reset'), body: {
        'email': userEmail,
      });
      switch (response.statusCode) {
        case 200:
          Navigator.of(context, rootNavigator: true)
              .pushNamed(RouteConstants.forgotPasswordResetCode);
          break;
        case 404:
          NotificationService.showError(context, response.body);
          break;
        default:
          NotificationService.showError(
              context, 'Erreur serveur. ${response.body}');
      }
    } catch (e) {
      NotificationService.showError(context, "Erreur serveur. ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    return TemplateTwoBlocks(
        appTitle: translationService.translate("FORGOT_PASSWORD_TITLE"),
        middleChild: Column(children: [
          Text(
            translationService.translate('FORGOT_PASSWORD_DESCRIPTION'),
            // textAlign: TextAlign.center,
            style: FigmaTextStyles().body16pt.copyWith(
                  color: FigmaColors.darkDark0,
                ),
          ),
          const SizedBox(height: 32.0),
          buildTextField(
            controller: _mailController,
            hintText: translationService.translate('PLACEHOLDER_TEXT_EMAIL'),
            labelText: translationService.translate('LABEL_TEXT_EMAIL'),
            key: "emailLostPasswordField",
          ),
        ]),
        bottomChild: Column(
          children: [
            buildButton(
              onPressed: () {
                sendMailForgotAccount();
              },
              text: translationService.translate("SEND_THE_CODE"),
            ),
            const SizedBox(height: 20.0),
            buildButton(
              variant: 'secondary',
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed(RouteConstants.forgotPasswordResetCode);
              },
              text: translationService.translate("ALREADY_HAVE_A_CODE"),
            ),
          ],
        ));
  }
}
