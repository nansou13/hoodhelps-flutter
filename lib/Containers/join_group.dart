import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/menu_widget.dart';
import 'package:hoodhelps/constants.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:hoodhelps/template.dart';
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
      var userData = userService.getUser();
    
    final groupeCode = _codeController.text.toLowerCase();
    if (groupeCode.isEmpty) {
      NotificationService.showError(
          context, "Veuillez saisir un code de groupe");
      return;
    }
    try {
      final response =
          await http.get(Uri.parse('$routeAPI/api/groups/code/$groupeCode'));
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

              Navigator.of(context).pushReplacementNamed('/splash');
            } else {
              // En cas d'échec de la requête, afficher un message d'erreur
              NotificationService.showError(
                  context, "Échec ajout du user dans le groupe $data");
            }
          } catch (e) {
            NotificationService.showError(context,
                "Erreur lors de la récupération des données du serveur. ${e.toString()}");
          }
          break;
        case 401:
          NotificationService.showError(
              context, json.decode(response.body)['error']);
          break;
        default:
          NotificationService.showError(context, json.decode(response.body));
      }
    } catch (e) {
      NotificationService.showError(context,
          "Erreur lors de la récupération des données du serveur. ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Rejoindre un groupe'),
        ),
        drawer: const MenuWidget(),
        body: Stack(
          children: [
            // Image de fond
            background(),

            Container(
              color: Colors.white.withOpacity(0.9),
              width: double.infinity,
              height: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(  // Ajout de SingleChildScrollView
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(10.0), // Ajoute 8 points de marge intérieure
                      child: const Column(children: [
                        //add image
                        Image(
                            image: AssetImage('assets/joinGroup.jpeg'),
                            // width: 100,
                          ),
            
                           Text(
                        "Saisissez le code du groupe que vous souhaitez rejoindre. Ce code vous permettra d'accéder au groupe et de collaborer avec d'autres membres.",
                        style: TextStyle(fontSize: 15.0),
                        textAlign: TextAlign.center,
                      ),
                      ],)
                    ),
                    const SizedBox(height: 20.0),
                    
                    TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight
                              .bold), // Personnalisez la taille et le style du texte
                      decoration: const InputDecoration(
                        hintText: 'Entrez le code',
                        hintStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight
                                .bold), // Personnalisez le style du texte d'infobulle
                      ),
                    ),
                    const SizedBox(height: 40), // Ajoute un espacement
                    MaterialButton(
                      onPressed: () {
                        fetchGroupeInfo();
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 50.0,
                        alignment: Alignment.center,
                        child: const Text(
                          'Entrer dans le groupe',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              
                ),
              ),
            ),
          ],
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
