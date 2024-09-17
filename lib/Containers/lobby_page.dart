import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/template_connected_page.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:provider/provider.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key? key}) : super(key: key);

  @override
  _LobbyPage createState() => _LobbyPage();
}

class _LobbyPage extends State<LobbyPage> {
  bool isLoading =
      true; // Ajoutez une variable pour gérer l'affichage du loader
  String appBarTitle = 'Home';

  void updateAppBarTitle(String newTitle) {
    setState(() {
      appBarTitle = newTitle;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    final user = Provider.of<UserService>(context, listen: false);
    final groups = user.groups;
    
    var groupId = user.currentGroupId;
    var categoryId = '';
    var groupBackgroundUrl = '';

    if(groupId != '') {
      Group specificGroup = groups.firstWhere(
      (group) => group.id == groupId,
      orElse: () => throw Exception('Groupe non trouvé'),
      );
      groupBackgroundUrl = specificGroup.backgroundUrl;
      updateAppBarTitle(specificGroup.name);
    }
    
    // if (arguments.length >= 2) {
    //   categoryId = arguments[1].toString();
    // }

    return ConnectedPage(
        showBottomNav: groupId != '',
        showLeading: categoryId.isNotEmpty,
        appTitle: appBarTitle,
        child: Column(
          children: [
            groupId == ''
                ? _buildNoGroupContent()
                : Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      if (groupBackgroundUrl.isNotEmpty)
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            maxHeight: 100,
                          ),
                          child: Image.network(
                            groupBackgroundUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 10.0),
                      Text(
                        translationService.translate('LOBBY_DESCRIPTION'),
                        style: const TextStyle(fontSize: 15.0),
                        textAlign: TextAlign.center,
                      ),
                    ]),
                  ),
          ],
        ));
  }

  Widget _buildNoGroupContent() {
    final translationService = context.read<TranslationService>();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20.0),
          Text(
            translationService.translate('NOT_IN_A_GROUP_MESSAGE'),
            style: const TextStyle(fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Card(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed(RouteConstants.joinGroup);
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
                      color: Color(0xFF2CC394),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 10.0),
                    child: Text(
                      translationService.translate('JOIN_A_GROUP'),
                      style: const TextStyle(
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
      ),
    );
  }
}
