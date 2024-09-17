import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/button_widget.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:provider/provider.dart';

class RegisterLoginPage extends StatefulWidget {
  const RegisterLoginPage({Key? key}) : super(key: key);

  @override
  _RegisterLoginPageState createState() => _RegisterLoginPageState();
}

class _RegisterLoginPageState extends State<RegisterLoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    return Scaffold(
      body: Stack(
        children: [
          appTitle(translationService),
          loginForm(translationService),
        ],
      ),
    );
  }

  Widget background() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height -
          250, // Ajuste la hauteur selon le contexte
      color: Color(0xFFF2F2F2),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround, // Espacement autour des images
        children: [
          Image.asset(
            'assets/clouds.png',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width - 40,
          ),
          Image.asset(
            'assets/group.png',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width - 40,
          ),
        ],
      ),
    );
  }

  Widget appTitle(TranslationService translationService) {
    return Stack(children: [
      background(),
      Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 8),
            SizedBox(
              child: Image(
                image: AssetImage('assets/icon.png'),
                width: MediaQuery.of(context).size.width * 0.3,
              ),
            ),
          ],
        ),
      )
    ]);
  }

  Widget loginForm(TranslationService translationService) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(20.0),
        width: double.infinity,
        height: 270,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              translationService.translate("APP_TITLE_DESC"),
              style: FigmaTextStyles().headingsh2,
            ),
            const SizedBox(height: 24.0),
            buildRegisterButton(translationService),
            const SizedBox(height: 10.0),
            buildConnectButton(translationService),
            const SizedBox(height: 10.0),
            forgotAccountLink(translationService),
          ],
        ),
      ),
    );
  }

  MaterialButton buildConnectButton(TranslationService translationService) {
    return buildButton(
      variant: 'secondary',
      onPressed: () {
        Navigator.pushNamed(context, RouteConstants.login);
      },
      text: translationService.translate("FORM_CONNECT_BUTTON"),
    );
  }

  MaterialButton buildRegisterButton(TranslationService translationService) {
    return buildButton(
      onPressed: () {
        Navigator.pushNamed(context, RouteConstants.register);
      },
      text: translationService.translate("FORM_CREATE_ACCOUNT_LINK"),
    );
  }

  InkWell forgotAccountLink(TranslationService translationService) {
    return InkWell(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RouteConstants.forgotPassword);
        },
        child: Text(
          translationService.translate("FORM_FORGOT_ACCOUNT_LINK"),
          style: FigmaTextStyles().stylizedMedium.copyWith(
                decoration: TextDecoration.underline, // Ajouter le soulignement
              ),
        ),
      ),
    );
  }
}
