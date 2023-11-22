import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/lobby_jobs.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/template.dart';
import 'package:hoodhelps/utils.dart';

import 'package:hoodhelps/Containers/menu_widget.dart';
import 'package:hoodhelps/Containers/lobby_category.dart';
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
    final List arguments = ModalRoute.of(context)!.settings.arguments as List;
    var groupId = '';
    var categoryId = '';
    if (arguments.isNotEmpty) {
      groupId = arguments[0].toString();
    }
    if (arguments.length >= 2) {
      categoryId = arguments[1].toString();
    }

    final translationService = context.read<TranslationService>();
    return Scaffold(
      appBar: AppBar(
        leading: categoryId.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
        title: Text(appBarTitle),
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
      body: Stack(
        children: [
          // Image de fond
          background(),

          Container(
            color: Colors.white.withOpacity(0.9),
            width: double.infinity,
            height: double.infinity,
            child: groupId == ''
                ? _buildNoGroupContent()
                : categoryId.isNotEmpty
                    ? GroupCategoryContent(
                        groupId: groupId,
                        categoryId: categoryId,
                        updateTitleCallback: updateAppBarTitle,
                      )
                    : GroupContent(
                        groupId: groupId,
                        updateTitleCallback: updateAppBarTitle),
          ),
        ],
      ),
    );
  }

  Widget _buildNoGroupContent() {
    final translationService = context.read<TranslationService>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 30.0),
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
              Navigator.of(context, rootNavigator: true).pushNamed(RouteConstants.joinGroup);
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
    );
  }
}
