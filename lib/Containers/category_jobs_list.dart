import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/categories_service.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:provider/provider.dart';

class CategoryJobsMainListPage extends StatefulWidget {
  const CategoryJobsMainListPage({super.key});

  @override
  CategoryJobsMainListPageState createState() => CategoryJobsMainListPageState();
}

class CategoryJobsMainListPageState extends State<CategoryJobsMainListPage> {
  String? categoryId;
  List categoryData = [];
  List jobData = [];
  String categorieName = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadJobsData(); // Appeler loadJobsData ici quand le contexte est prêt
  }

  Future<void> loadJobsData() async {
    final List<dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>?;

    try {
      final CategoriesService categoriesService = CategoriesService();
      final user = Provider.of<UserService>(context, listen: false);

      // Utiliser la variable `categoryId` de l'état du widget
      if (arguments != null && arguments.isNotEmpty) {
        setState(() {
          categoryId = arguments[0].toString();
        });
      }

      var groupId = user.currentGroupId;

      final data = await categoriesService.getCacheCategoryData(groupId);

      // Filtrer les éléments de la liste avec le nom de catégorie correspondant
      var categoryData = data.firstWhere(
        (category) => category['id'] == categoryId,
        orElse: () => null,
      );

      List<dynamic> professions = [];
      if (categoryData != null) {
        professions =
            reorderProfessionsByUserCount(categoryData['professions']);
      }

      setState(() {
        jobData =
            professions; // Mettez à jour la liste une fois les données chargées
        categorieName = categoryData['name'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      NotificationService.showError(
          "Erreur lors du chargement des données: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    // Affichage de la variable categoryId dans le build

    return Scaffold(
        appBar: genericAppBar(
          appTitle: translationService.translate(categorieName),
          context: context,
        ),
        backgroundColor:
            FigmaColors.lightLight4, // Fond noir pour toute la page
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : (categoryId == null || categoryId!.isEmpty)
                ? Scaffold(
                    backgroundColor: FigmaColors.lightLight4,
                    body: Center(
                      child: Text(translationService.translate('NO_CATEGORY_SELECTED')),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    width: double.infinity,
                    child: SingleChildScrollView(
                        child: Container(
                            padding: const EdgeInsets.all(14.0),
                            decoration: const BoxDecoration(
                                color: FigmaColors.lightLight3,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                )),
                            child: Column(
                              children: [
                                ...jobData.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  Map<String, dynamic> value = entry.value;

                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: value['user_count'] == 0
                                            ? null // Désactiver le clic si user_count == 0
                                            : () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pushNamed(
                                                  RouteConstants.userMainList,
                                                  arguments: [
                                                    categoryId,
                                                    value['profession_id']
                                                  ],
                                                );
                                              },
                                        child: Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
          child: Text(
                                                translationService.translate(value[
                                                    'profession_name']), // Affiche la valeur à gauche
                                                style: const FigmaTextStyles()
                                                    .body16pt
                                                    .copyWith(
                                                      color:
                                                          value['user_count'] ==
                                                                  0
                                                              ? FigmaColors
                                                                  .darkDark3
                                                              : FigmaColors
                                                                  .darkDark0,
                                                    ),
                                                    maxLines: 1, // Limite à 2 lignes
                                                    overflow: TextOverflow.ellipsis,
                                              ),
                                              ),
                                              Icon(
                                                value['user_count'] == 0
                                                    ? Icons
                                                        .block // Icône "interdit" si user_count == 0
                                                    : Icons
                                                        .arrow_forward_ios, // Icône flèche si user_count > 0
                                                size: 16,
                                                color: value['user_count'] == 0
                                                    ? FigmaColors.darkDark3
                                                    : FigmaColors.darkDark0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (index !=
                                          jobData.length -
                                              1) // Ne pas ajouter la ligne après le dernier élément
                                        const Divider(
                                          color: FigmaColors
                                              .lightLight1, // Ligne noire entre les éléments
                                          thickness: 1,
                                        ),
                                    ],
                                  );
                                }),
                              ],
                            )))));
  }

  List<dynamic> reorderProfessionsByUserCount(List<dynamic> professionData) {
    // Filtrer les professions avec et sans utilisateurs
    List<dynamic> professionsWithUsers = professionData.where((profession) {
      int userCount = int.tryParse(profession['user_count'].toString()) ?? 0;
      return userCount > 0;
    }).toList();

    List<dynamic> professionsWithoutUsers = professionData.where((profession) {
      int userCount = int.tryParse(profession['user_count'].toString()) ?? 0;
      return userCount == 0;
    }).toList();

    // Retourner les professions triées : celles avec utilisateurs d'abord, puis les autres
    return [...professionsWithUsers, ...professionsWithoutUsers];
  }

  List<dynamic> reorderCategoriesByUserCount(
      List<dynamic> categoryDataToFormat) {
    // Filtrer les catégories avec et sans utilisateurs
    List<dynamic> categoriesWithUsers = categoryDataToFormat.where((category) {
      int usersCount = int.tryParse(category['users'].toString()) ?? 0;
      return usersCount > 0;
    }).toList();

    List<dynamic> categoriesWithoutUsers =
        categoryDataToFormat.where((category) {
      int usersCount = int.tryParse(category['users'].toString()) ?? 0;
      return usersCount == 0;
    }).toList();

    // Retourne les catégories triées
    return [...categoriesWithUsers, ...categoriesWithoutUsers];
  }
}
