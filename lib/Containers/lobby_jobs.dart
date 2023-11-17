import 'package:flutter/material.dart';
import 'package:hoodhelps/services/categories_service.dart';
import 'package:hoodhelps/services/icons_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:provider/provider.dart';

class GroupCategoryContent extends StatefulWidget {
  final String groupId;
  final String categoryId;
  final Function(String newTitle) updateTitleCallback;

  const GroupCategoryContent(
      {Key? key,
      required this.groupId,
      required this.categoryId,
      required this.updateTitleCallback})
      : super(key: key);

  @override
  _GroupCategoryContentState createState() => _GroupCategoryContentState();
}

class _GroupCategoryContentState extends State<GroupCategoryContent> {
  List jobData = [];
  String categorieName = '';

  @override
  void initState() {
    super.initState();
    loadJobsData(); // Initialisez la fonction loadjobData ici.
  }

  Future<void> loadJobsData() async {
    final translationService = context.read<TranslationService>();
    final CategoriesService categoriesService = CategoriesService();
    final groupId = widget.groupId;
    final data = await categoriesService.getCacheCategoryData(groupId);

    // Filtrer les éléments de la liste avec le nom de catégorie correspondant
    var categoryData = data.firstWhere(
      (category) => category['id'] == widget.categoryId,
      orElse: () => null,
    );

    List<dynamic> professions = [];
    if (categoryData != null) {
      professions = categoryData['professions'];
    }
    setState(() {
      jobData =
          professions; // Mettez à jour la liste une fois les données chargées
      categorieName = categoryData['name'];
      widget.updateTitleCallback(translationService.translate(categorieName));
    });
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    final groupId = widget.groupId;
    final categoryId = widget.categoryId;

    var groupBackgroundUrl =
        categorieName.isNotEmpty ? 'assets/categories/$categorieName.jpg' : '';

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
                  child: Image(
                    image: AssetImage(groupBackgroundUrl),
                    fit: BoxFit.cover,
                    // width: 100,
                  ),
                ),
              const SizedBox(height: 10.0),
              Text(
                "${translationService.translate("YOU_SELECTED_THE_CATEGORY")} ${translationService.translate(categorieName)}. ${translationService.translate("LOBBY_CATEGORY_DESCRIPTION")}}",
                style: const TextStyle(fontSize: 15.0),
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
              physics:
                  const NeverScrollableScrollPhysics(), // Empêcher le GridView de défiler
              shrinkWrap:
                  true, // Permettre au GridView de s'adapter à son contenu
              itemCount: jobData.length,
              itemBuilder: (context, index) {
                final job = jobData[index];
                final jobId =
                    job['profession_id']; // Récupérez l'ID de la catégorie
                final jobName = job['profession_name'];
                final jobUsers =
                    int.tryParse(job['user_count'].toString()) ?? 0;

                return GestureDetector(
                  behavior: jobUsers > 0
                      ? HitTestBehavior.opaque
                      : HitTestBehavior.translucent,
                  onTap: () {
                    if (jobUsers > 0) {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        '/userlist',
                        arguments: [groupId, categoryId, jobId],
                      );
                    }
                  },
                  child: Card(
                    color: jobUsers > 0 ? Colors.white : Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(IconsExtension.getIconData(jobName),
                            size: 60.0,
                            color: jobUsers > 0
                                ? Colors.black
                                : Colors.grey[
                                    400]), // Affichez l'icône ici à gauche

                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 10.0),
                          child: Text(
                            translationService.translate(jobName),
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
