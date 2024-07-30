import 'package:flutter/material.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/categories_service.dart';
import 'package:hoodhelps/services/icons_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:provider/provider.dart';

class JobDisplayGrid extends StatefulWidget {
  const JobDisplayGrid({Key? key}) : super(key: key);

  @override
  _JobDisplayGridState createState() => _JobDisplayGridState();
}

class _JobDisplayGridState extends State<JobDisplayGrid> {
  List categoryData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadCategoryData(); // Initialisez la fonction loadCategoryData ici.
  }

  Future<void> loadCategoryData() async {
    final CategoriesService categoriesService = CategoriesService();

    final user = Provider.of<UserService>(context, listen: false);
    final groupId = user.currentGroupId;

    final data = await categoriesService.getCacheCategoryData(groupId);

    setState(() {
      categoryData =
          data; // Mettez à jour la liste une fois les données chargées
    });
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      physics:
          const NeverScrollableScrollPhysics(), // Empêcher le GridView de défiler
      shrinkWrap: true, // Permettre au GridView de s'adapter à son contenu
      itemCount: categoryData.length,
      itemBuilder: (context, index) {
        final category = categoryData[index];
        final categoryName = category['name'];
        //force category['users'] to be an int to avoid error when null (null is not a subtype of int)

        final categoryUsers = int.tryParse(category['users'].toString()) ?? 0;
        final categoryId = category['id']; // Récupérez l'ID de la catégorie

        return GestureDetector(
          behavior: categoryUsers > 0
              ? HitTestBehavior.opaque
              : HitTestBehavior.translucent,
          onTap: () {
            if (categoryUsers > 0) {
              Navigator.of(context, rootNavigator: true).pushNamed(
                RouteConstants.jobMainList,
                arguments: [categoryId],
              );
            }
          },
          child: Card(
            color: categoryUsers > 0 ? Colors.white : Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(IconsExtension.getIconData(categoryName),
                    size: 40.0,
                    color: categoryUsers > 0
                        ? Colors.black
                        : Colors.grey[400]), // Affichez l'icône ici à gauche

                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  child: Text(
                    translationService.translate(categoryName),
                    style: const TextStyle(
                      fontSize: 10.0,
                    ),
                    textAlign: TextAlign.center, // Centrer le texte
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
