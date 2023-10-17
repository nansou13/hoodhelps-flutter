import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/group_widget.dart';
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
    final firstInitial = user.firstName != null && user.firstName!.isNotEmpty
        ? user.firstName![0]
        : '';
    final lastInitial = user.lastName != null && user.lastName!.isNotEmpty
        ? user.lastName![0]
        : '';
    final groups = user.groups;

    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(FunctionUtils.capitalizeFirstLetter(fullname)),
            accountEmail: Text(user.email ?? ""),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text(
                '${firstInitial.toUpperCase()}${lastInitial.toUpperCase()}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ...groups.map((group) => GroupCard(
                name: group.name,
                address: group.address,
                cp: group.cp,
                city: group.city,
                backgroundUrl: group.backgroundUrl,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    '/lobby',
                    arguments: [group.id],
                  );
                  // redirect to /lobby
                },
              )),
          Card(
            color: Colors.white, // Couleur de l'arrière-plan de la carte
            child: InkWell(
              onTap: () {
                // Gérez l'action de clic ici
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity, // Prend la largeur complète
                    height: 50.0, // Hauteur de la carte
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.add,
                      size: 40.0, // Taille de l'icône "ajouter"
                      color: Colors.blue, // Couleur de l'icône "ajouter"
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
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 20.0), // Ajustez l'espacement en bas ici
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: Text(translationService.translate('DISCONNECT_BUTTON')),
                onTap: () {
                  FunctionUtils.disconnectUser(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
