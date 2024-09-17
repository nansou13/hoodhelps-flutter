import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/button_widget.dart';
import 'package:hoodhelps/custom_colors.dart';
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
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleTextStyle: FigmaTextStyles().headingsh3.copyWith(
              color: FigmaColors.darkDark0,
            ),
          leading: null,
          title: Text(translationService.translate("FORM_FORGOT_ACCOUNT_LINK")),
        ),
        body: 
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      
                        
                        Text(
                          translationService
                              .translate('UPDATE_PASSWORD_SUCCESS'),
                          style: FigmaTextStyles().body16pt.copyWith(
                      color: FigmaColors.darkDark0,
                    ),
                        ),
                      const SizedBox(height: 40.0),
                      buildButton(onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(RouteConstants.login);
                        }, text: translationService.translate("GO_TO_LOGIN")), 

                      
                  ],
                ),
              ),
            ),
        );
  }
}
