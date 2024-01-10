import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/textfield_widget.dart';
import 'package:hoodhelps/constants.dart';
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
          title: Text(translationService.translate("FORM_FORGOT_ACCOUNT_LINK")),
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
                                      .translate('FORGOT_PASSWORD_DESCRIPTION'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Color(0xFF696969),
                                  ),
                                ),
                              ]),
                              buildTextField(
                                controller: _mailController,
                                hintText: translationService
                                    .translate('LABEL_TEXT_EMAIL'),
                                key: "emailLostPasswordField",
                              ),
                              Column(
                                children: [
                                  MaterialButton(
                                    onPressed: () {
                                      sendMailForgotAccount();
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
                                            .translate("SEND_THE_CODE"),
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pushNamed(RouteConstants
                                              .forgotPasswordResetCode);
                                    },
                                    textColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: Color(0xFF102820)),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: 50.0,
                                      alignment: Alignment.center,
                                      child: Text(
                                        translationService
                                            .translate("ALREADY_HAVE_A_CODE"),
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )));
              }),
            ),
          ],
        ));
  }
}
