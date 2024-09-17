import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Modules/jobs/Job_display_grid.dart';
import 'package:hoodhelps/services/categories_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:provider/provider.dart';

class JobDisplay extends StatefulWidget {
  final Function(String newTitle) updateTitleCallback;

  const JobDisplay({Key? key, required this.updateTitleCallback})
      : super(key: key);

  @override
  _JobDisplayState createState() => _JobDisplayState();
}

enum LobbyView { grid, list }

class _JobDisplayState extends State<JobDisplay> {
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
    final groupId = user.currentGroupId;
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
    return SingleChildScrollView(
      // Utilisez SingleChildScrollView pour rendre tout le contenu déroulable
      child: JobDisplayGrid(),
    );
  }
}
