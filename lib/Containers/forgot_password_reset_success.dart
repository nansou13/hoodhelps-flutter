import 'package:flutter/material.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:provider/provider.dart';

class ForgotPasswordResetSuccess extends StatelessWidget {
  const ForgotPasswordResetSuccess({Key? key}) : super(key: key);

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
          leading: null,
          title: Text(translationService.translate("FORM_FORGOT_ACCOUNT_LINK")),
        ),
        body: Stack(
          children: [
            Container(
              color: Color(0xFFF2F2F2),
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: SingleChildScrollView(
                  // Ajout de SingleChildScrollView
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(children: [
                        const Image(
                          image: AssetImage('assets/cuate.png'),
                          height: 200,
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          translationService
                              .translate('UPDATE_PASSWORD_SUCCESS'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Color(0xFF696969),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 40.0),
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(RouteConstants.login);
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
                            translationService.translate("GO_TO_LOGIN"),
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
