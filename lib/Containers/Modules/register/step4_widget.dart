import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Modules/register/progress_bar_widget.dart';
import 'package:hoodhelps/Containers/Widgets/button_widget.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/Containers/Widgets/textfield_widget.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/api_service.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/utils.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Step4Widget extends StatefulWidget {
  final Function nextStepCallback;

  const Step4Widget({super.key, required this.nextStepCallback});

  @override
  Step4WidgetState createState() => Step4WidgetState();
}

class Step4WidgetState extends State<Step4Widget> {
  final TextEditingController _codeController = CodeInputController();

  @override
  void initState() {
    super.initState();

    // Récupérer et utiliser le code depuis les SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      final joinGroupCode = prefs.getString('joinGroupCode');
      if (joinGroupCode != null && joinGroupCode.isNotEmpty) {
        setState(() {
          _codeController.text = joinGroupCode;
        });
        // Effacer le code après l'avoir utilisé
        prefs.remove('joinGroupCode');
      }
    });
  }

  Future<void> fetchGroupeInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('user_id');
    final groupeCode = _codeController.text.toLowerCase();
    if (groupeCode.isEmpty) {
      NotificationService.showError(
          "Veuillez saisir un code de groupe");
      return;
    }
    try {
      final response = await ApiService().get('/groups/code/$groupeCode');
      switch (response.statusCode) {
        case 200:
          final codeID = json.decode(response.body)['id'];
          try {
            final addUserInGroup = await ApiService().post(
              '/groups/$codeID/user',
              body: {"user_id": userID},
            );

            final data = jsonDecode(response.body);

            if (addUserInGroup.statusCode == 201) {
              // Si la requête réussit (statut 200), analyser la réponse JSON

              Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(RouteConstants.splash);
            } else {
              // En cas d'échec de la requête, afficher un message d'erreur
              NotificationService.showError(
                  "Échec ajout du user dans le groupe $data");
            }
          } catch (e) {
            NotificationService.showError(
                "Erreur lors de la récupération des données du serveur. ${e.toString()}");
          }
          break;
        case 401:
          NotificationService.showError(
              json.decode(response.body)['error']);
          break;
        default:
          NotificationService.showError( json.decode(response.body));
      }
    } catch (e) {
      NotificationService.showError(
          "Erreur lors de la récupération des données du serveur. ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    return genericSafeAreaTwoBlocks(
        middleChild: Column(children: [
          const ProgressBarWithCounter(currentStep: 4, totalSteps: 4),
          const SizedBox(height: 30.0),
          Image.asset(
            'assets/join_group.png',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 14.0),
          Text(
            translationService.translate('STEP4_DESCRIPTION'),
            style: const FigmaTextStyles().body14pt.copyWith(
                  color: FigmaColors.darkDark2,
                ),
          ),
          const SizedBox(height: 34.0),
          buildTextField(
            controller: _codeController,
            hintText: translationService.translate('HINT_TEXT_ENTER_CODE'),
            labelText: translationService.translate('HINT_TEXT_ENTER_CODE'),
            key: 'codeField',
          ),
        ]),
        bottomChild: Column(
          children: [
            buildButton(
              onPressed: () {
                fetchGroupeInfo();
              },
              text: translationService.translate('JOIN_THE_GROUP'),
            ),
            const SizedBox(height: 20.0),
            buildButton(
              variant: "secondary",
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(RouteConstants.splash);
              },
              text: translationService.translate('SKIP_BUTTON'),
            ),
          ],
        ));

    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: <Widget>[
    //     const Image(
    //       image: AssetImage('assets/joindGroup.png'),
    //       height: 200,
    //     ),
    //     Column(children: [
    //       Text(
    //         translationService.translate('STEP4_TITLE'),
    //         style: const TextStyle(
    //           fontSize: 18.0,
    //           fontWeight: FontWeight.bold,
    //           color: Color(0xFF50B498),
    //         ),
    //       ),
    //       const SizedBox(height: 10.0),
    //       Text(
    //         translationService.translate('STEP4_DESCRIPTION'),
    //         textAlign: TextAlign.center,
    //         style: const TextStyle(
    //           fontSize: 15.0,
    //           color: Color(0xFF696969),
    //         ),
    //       ),
    //     ]),
    //     TextField(
    //       controller: _codeController,
    //       textAlign: TextAlign.center,
    //       style: const TextStyle(
    //           fontSize: 32,
    //           fontWeight: FontWeight
    //               .bold), // Personnalisez la taille et le style du texte
    //       decoration: InputDecoration(
    //         hintText: translationService.translate('HINT_TEXT_ENTER_CODE'),
    //         hintStyle: const TextStyle(
    //             fontSize: 24,
    //             fontWeight: FontWeight
    //                 .bold), // Personnalisez le style du texte d'infobulle
    //       ),
    //     ),
    //     Column(
    //       children: [
    //         MaterialButton(
    //           onPressed: () {
    //             fetchGroupeInfo();
    //           },
    //           color: Color(0xFF102820),
    //           textColor: Colors.white,
    //           elevation: 0,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10.0),
    //           ),
    //           child: Container(
    //             width: double.infinity,
    //             height: 50.0,
    //             alignment: Alignment.center,
    //             child: Text(
    //               translationService.translate('JOIN_THE_GROUP'),
    //               style: const TextStyle(
    //                 fontSize: 16.0,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //         ),
    //         const SizedBox(height: 20.0),
    //         MaterialButton(
    //           onPressed: () {
    //             Navigator.of(context)
    //                 .pushReplacementNamed(RouteConstants.splash);
    //           },
    //           textColor: Colors.black,
    //           elevation: 0,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10.0),
    //             side: const BorderSide(color: Color(0xFF102820)),
    //           ),
    //           child: Container(
    //             width: double.infinity,
    //             height: 50.0,
    //             alignment: Alignment.center,
    //             child: Text(
    //               translationService.translate('SKIP_BUTTON'),
    //               style: const TextStyle(
    //                 fontSize: 16.0,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     )
    //   ],
    // );
  }
}

class CodeInputController extends TextEditingController {
  CodeInputController() {
    // Écoutez les modifications du texte en temps réel
    addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // Obtenez le texte actuel
    final currentText = text;

    // Supprimez tous les tirets existants
    final textWithoutDashes = currentText.replaceAll('-', '');

    // Mettez le texte en majuscules
    final upperCaseText = textWithoutDashes.toUpperCase();

    // Formatez le texte avec des tirets tous les 4 caractères
    String formattedText = '';
    for (var i = 0; i < upperCaseText.length; i++) {
      formattedText += upperCaseText[i];
      if ((i + 1) % 4 == 0 && i != upperCaseText.length - 1) {
        formattedText += '-';
      }
    }

    // Si le texte formaté est différent du texte actuel, mettez à jour le champ
    if (formattedText != currentText) {
      value = value.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }
}
