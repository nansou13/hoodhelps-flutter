import 'package:flutter/material.dart';
import 'package:hoodhelps/services/categories_service.dart';
import 'package:hoodhelps/services/icons_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:provider/provider.dart';

class GroupContent extends StatefulWidget {
  final String groupId;
  final Function(String newTitle) updateTitleCallback;

  const GroupContent({Key? key, required this.groupId,required this.updateTitleCallback}) : super(key: key);

  @override
  _GroupContentState createState() => _GroupContentState();
}

class _GroupContentState extends State<GroupContent> {
  List categoryData = [];
  String groupBackgroundUrl = '';

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
    final groupId = widget.groupId;

    return SingleChildScrollView( // Utilisez SingleChildScrollView pour rendre tout le contenu déroulable
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
            const Text(
              "Trouver le bon professionnel près de chez vous n'a jamais été aussi simple. Parcourez les différentes catégories de métiers ci-dessous pour découvrir les talents qui se cachent dans votre résidence.",
              style: TextStyle(fontSize: 15.0),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            physics: const NeverScrollableScrollPhysics(), // Empêcher le GridView de défiler
            shrinkWrap: true, // Permettre au GridView de s'adapter à son contenu
            itemCount: categoryData.length,
            itemBuilder: (context, index) {
                final category = categoryData[index];
                final categoryName = category['name'];
                //force category['users'] to be an int to avoid error when null (null is not a subtype of int)

                final categoryUsers =
                    int.tryParse(category['users'].toString()) ?? 0;
                final categoryId =
                    category['id']; // Récupérez l'ID de la catégorie

                return GestureDetector(
                  behavior: categoryUsers > 0
                      ? HitTestBehavior.opaque
                      : HitTestBehavior.translucent,
                  onTap: () {
                    if (categoryUsers > 0) {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        '/lobby',
                        arguments: [groupId, categoryId],
                      );
                    }
                  },
                  child: Card(
                    color: categoryUsers > 0 ? Colors.white : Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(IconsExtension.getIconData(categoryName),
                            size: 60.0,
                            color: categoryUsers > 0
                                ? Colors.black
                                : Colors.grey[
                                    400]), // Affichez l'icône ici à gauche

                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 10.0),
                          child: Text(
                            translationService.translate(categoryName),
                            style: const TextStyle(
                              fontSize: 15.0,
                            ),
                            textAlign: TextAlign.center, // Centrer le texte
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
          ),
            ),
          ],
        ),
    );
  }
}
