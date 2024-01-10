import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/lobby_category_grid.dart';
import 'package:hoodhelps/Containers/lobby_category_list.dart';
import 'package:hoodhelps/services/categories_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:provider/provider.dart';

class GroupContent extends StatefulWidget {
  final String groupId;
  final Function(String newTitle) updateTitleCallback;

  const GroupContent(
      {Key? key, required this.groupId, required this.updateTitleCallback})
      : super(key: key);

  @override
  _GroupContentState createState() => _GroupContentState();
}

enum LobbyView { grid, list }

class _GroupContentState extends State<GroupContent> {
  List categoryData = [];
  String groupBackgroundUrl = '';
  bool isLoading = false;

  LobbyView lobbyView = LobbyView.grid; // Défaut à grille

  @override
  void initState() {
    super.initState();
    loadCategoryData(); // Initialisez la fonction loadCategoryData ici.
  }

  Future<void> loadCategoryData() async {
    final CategoriesService categoriesService = CategoriesService();
    final user = Provider.of<UserService>(context, listen: false);
    final groupId = widget.groupId;
    final groups = user.groups;
    Group specificGroup = groups.firstWhere(
      (group) => group.id == groupId,
      orElse: () => throw Exception('Groupe non trouvé'),
    );

    final data = await categoriesService.getCacheCategoryData(groupId);
    setState(() {
      categoryData =
          data; // Mettez à jour la liste une fois les données chargées
      widget.updateTitleCallback(specificGroup.name);
      groupBackgroundUrl = specificGroup.backgroundUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();

    return SingleChildScrollView(
      // Utilisez SingleChildScrollView pour rendre tout le contenu déroulable
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 30.0),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
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
          const SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.only(right: 20), // Padding à droite
            child: Align(
                alignment: Alignment.topRight,
                child: SegmentedButton(
                  showSelectedIcon: false,
                  segments: const <ButtonSegment>[
                    ButtonSegment(
                        value: LobbyView.grid, icon: Icon(Icons.grid_view)),
                    ButtonSegment(
                        value: LobbyView.list, icon: Icon(Icons.people_alt)),
                  ],
                  selected: {lobbyView},
                  onSelectionChanged: (Set newSelection) {
                    setState(() {
                      // By default there is only a single segment that can be
                      // selected at one time, so its value is always the first
                      // item in the selected set.

                      lobbyView = newSelection.first;
                    });
                  },
                )),
          ),
          buildLobbyView(),
        ],
      ),
    );
  }

  Widget buildLobbyView() {
    switch (lobbyView) {
      case LobbyView.grid:
        return GroupContentGrid(groupId: widget.groupId);
      case LobbyView.list:
        return GroupContentList(groupId: widget.groupId);
      default:
        return GroupContentGrid(groupId: widget.groupId);
    }
  }
}