import 'package:flutter/material.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:hoodhelps/utils.dart';
import 'package:provider/provider.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  _MenuWidget createState() => _MenuWidget();
}

class _MenuWidget extends State<MenuWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    final user = Provider.of<UserService>(context);
    final fullname = (user.firstName ?? '') + ' ' + (user.lastName ?? '');
    final firstInitial = user.firstName != null && user.firstName!.isNotEmpty ? user.firstName![0] : '';
    final lastInitial = user.lastName != null && user.lastName!.isNotEmpty ? user.lastName![0] : '';

    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(FunctionUtils.capitalizeFirstLetter(fullname)),
            accountEmail: Text(user.email ?? ""),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blueGrey, // Couleur de fond du cercle
              child: Text(
                '${firstInitial.toUpperCase()}${lastInitial.toUpperCase()}', // Les deux premières lettres du prénom et du nom
                style: const TextStyle(
                  fontSize: 24, // Taille du texte
                  color: Colors.white, // Couleur du texte
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical:
                    8.0), // Ajustez la valeur de la marge verticale selon vos besoins
            child: ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/lobby');
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: const <Widget>[
                // Ajoutez d'autres éléments de menu ici
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom:
                    30.0), // Ajustez la valeur de la marge inférieure selon vos besoins
            child: ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text(translationService.translate('DISCONNECT_BUTTON')),
              onTap: () {
                FunctionUtils.disconnectUser(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
