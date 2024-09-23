import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/Containers/Widgets/textfield_widget.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class JoinGroup extends StatefulWidget {
  const JoinGroup({Key? key}) : super(key: key);

  @override
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  final TextEditingController _codeController = CodeInputController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchGroupeInfo() async {
    final userService = Provider.of<UserService>(context, listen: false);
    final translationService = context.read<TranslationService>();

    var userData = userService.getUser();

    final groupeCode = _codeController.text.toLowerCase();
    if (groupeCode.isEmpty) {
      NotificationService.showError(context,
          translationService.translate("NOTIF_PLEASE_ENTER_GROUP_CODE"));
      return;
    }
    try {
      final response =
          await http.get(Uri.parse('$routeAPI/api/groups/code/$groupeCode'));
          print(response.body);
      switch (response.statusCode) {
        case 200:
          final codeID = json.decode(response.body)['id'];
          try {
            final addUserInGroup = await http
                .post(Uri.parse('$routeAPI/api/groups/$codeID/user'), body: {
              "user_id": userData['id'].toString(),
            });
            final data = jsonDecode(response.body);

            if (addUserInGroup.statusCode == 201) {
              // Si la requête réussit (statut 200), analyser la réponse JSON

              Navigator.of(context).pushReplacementNamed(RouteConstants.splash);
            } else {
              // En cas d'échec de la requête, afficher un message d'erreur
              NotificationService.showError(
                  context, "Échec ajout du user dans le groupe $data");
            }
          } catch (e) {
            NotificationService.showError(context,
                "Erreur lors de la récupération des données du serveur. ${e}");
          }
          break;
        case 404:
          // Récupérer le message d'erreur à partir du body JSON
          final Map<String, dynamic> responseBody = json.decode(response.body);
          NotificationService.showError(context, responseBody['error']);
          break;
        case 401:
        final responseBody = json.decode(response.body);
        NotificationService.showError(context, responseBody['error']);
        break;

      default:
        final responseBody = json.decode(response.body);
        NotificationService.showError(context, responseBody['error'] ?? 'Erreur inattendue');
    
      }
    } catch (e) {
      print(e);
      NotificationService.showError(context,
          "Erreur lors de la récupération des données du serveur.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    return Scaffold(
      appBar: genericAppBar(context: context, appTitle: translationService.translate("JOIN_A_GROUP")),
      body: genericSafeAreaTwoBlocks(
        middleChild: Column(children: [
          Image.asset(
            'assets/join_group.png',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width ,
          ),
          const SizedBox(height: 14.0),
          Text(
            translationService.translate('STEP4_DESCRIPTION'),
            style: FigmaTextStyles().body14pt.copyWith(
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
        bottomChild: 
          MaterialButton(
                    onPressed: () {
                      fetchGroupeInfo();
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
                        translationService.translate('JOIN_THE_GROUP'),
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
      ),
    );
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
