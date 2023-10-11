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
        body: const Center(
          child: Text('Contenu de l\'application'),
        ),
      ),
    );
  }
}
