import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/job_users.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/categories_service.dart';
import 'package:hoodhelps/services/icons_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:provider/provider.dart';

class GroupContentList extends StatefulWidget {
  final String groupId;

  const GroupContentList(
      {Key? key, required this.groupId})
      : super(key: key);

  @override
  _GroupContentListState createState() => _GroupContentListState();
}

class _GroupContentListState extends State<GroupContentList> {
  List userData = [];
  List usersCategories = [];
  List usersJobs = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loaduserData(); // Initialisez la fonction loaduserData ici.
  }

  Future<void> loaduserData() async {
    final CategoriesService categoriesService = CategoriesService();
    final groupId = widget.groupId;

    final data = await categoriesService.getCacheCategoryDataList(groupId);

    var categoryIds = <String>{};
    var jobIds = <String>{};

    // Parcourez chaque utilisateur
    for (var user in data) {
      // Parcourez chaque métier de l'utilisateur
      for (var job in user['jobs']) {
        // Ajoutez l'identifiant de la catégorie et du métier aux ensembles
        categoryIds.add(job['category_id']);
        jobIds.add(job['job_id']);
      }
    }

    // Convertissez les ensembles en listes
    List<String> uniqueCategoryIds = categoryIds.toList();
    List<String> uniqueJobIds = jobIds.toList();

    setState(() {
      userData =
          data; // Mettez à jour la liste une fois les données chargées
      usersCategories = uniqueCategoryIds;
      usersJobs = uniqueJobIds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        physics:
            const NeverScrollableScrollPhysics(), // Empêcher le GridView de défiler
        shrinkWrap: true, // Permettre au GridView de s'adapter à son contenu
        itemCount: userData.length,
        itemBuilder: (context, index) {
          final user = userData[index];
          // final categoryId = user['category_id'];
          final jobName = user['job_name'];
          final jobID = user['job_id'];
          final userImageUrl = user['image_url'] ?? '';
          final userNameDisplay = displayName(user['first_name'],
                        user['last_name'], user['username']);

          return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pushNamed(
                          RouteConstants.userInfo,
                          arguments: [user['user_id'], jobID, jobName, widget.groupId],
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 20.0),
                            CircleAvatar(
                              backgroundImage: userImageUrl.isNotEmpty
                                  ? NetworkImage(userImageUrl)
                                  : null,
                              backgroundColor: Colors.blueGrey,
                              radius: 50.0,
                              child: Text(
                                userImageUrl.isEmpty
                                    ? '${user['first_name'].isNotEmpty ? user['first_name'][0] : ''}${user['last_name'].isNotEmpty ? user['last_name'][0] : ''}'
                                        .toUpperCase()
                                    : '',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              userNameDisplay,
                              style: const TextStyle(
                                fontSize: 15.0,
                              ),
                              textAlign: TextAlign.center, // Centrer le texte
                            ),
                          ],
                        ),
                      ),
                    );
        },
      ),
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String categoryId; // Identifiant de la catégorie
  final String categoryName; // Identifiant de la catégorie
  final categoryUsers;

  const CustomExpansionTile({Key? key, required this.categoryId, required this.categoryName, required this.categoryUsers}) : super(key: key);

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  var users = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    print(widget.categoryUsers);
    final translationService = context.read<TranslationService>();
    return ExpansionTile(
      leading: Icon(IconsExtension.getIconData(widget.categoryName),
                      size: 25.0,
                      color: widget.categoryUsers.length > 0
                          ? Colors.black
                          : Colors.grey[400]), // Remplacez par votre icône de catégorie
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
                      translationService.translate(widget.categoryName),
                      style: const TextStyle(
                        fontSize: 15.0,
                      )),
        ],
      ),
      // children: _buildExpansionContent(widget.categoryUsers),
      children: widget.categoryUsers.map<Widget>((user) {
        return _buildExpansionContent(user);
      }).toList(),
    );
  }

  Widget _buildExpansionContent(user) {
    // Créez ici le contenu de votre ExpansionTile
    return ListTile(title: Text(user['first_name']));
  }
}