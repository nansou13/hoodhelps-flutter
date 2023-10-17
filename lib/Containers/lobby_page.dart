import 'package:flutter/material.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/utils.dart';

import 'package:hoodhelps/Containers/menu_widget.dart';
import 'package:provider/provider.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key? key}) : super(key: key);

  @override
  _LobbyPage createState() => _LobbyPage();
}

class _LobbyPage extends State<LobbyPage> {
  bool isLoading =
      true; // Ajoutez une variable pour gérer l'affichage du loader

  @override
  void initState() {
    super.initState();
    // _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    final groupId = arguments.toString();

    final translationService = context.read<TranslationService>();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mon Lobby'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: translationService.translate('DISCONNECT_BUTTON'),
              onPressed: () {
                FunctionUtils.disconnectUser(context);
              },
            ),
          ],
        ),
        drawer: const MenuWidget(),
        body: Center(
          child:
              groupId == 'null' ? _buildNoGroupContent() : _buildGroupContent(),
        ),
      ),
    );
  }

  Widget _buildNoGroupContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 30.0),
        const Text(
          'Vous n\'êtes pas encore membre d\'un groupe',
          style: TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20.0),
        Card(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              // Gérez l'action de clic ici
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 50.0,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.add,
                    size: 40.0,
                    color: Colors.blue,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 10.0),
                  child: Text(
                    "Rejoindre un groupe",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupContent() {
    // Remplacez ce widget par le contenu à afficher lorsque groupId n'est pas 'null'
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 30.0),
        Text(
          'Liste des category',
          style: TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}