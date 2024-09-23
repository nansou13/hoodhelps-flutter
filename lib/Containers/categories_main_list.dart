import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/color_mapping.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/categories_service.dart';
import 'package:hoodhelps/services/icons_service.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:provider/provider.dart';

class CategoriesMainListPage extends StatefulWidget {
  const CategoriesMainListPage({Key? key}) : super(key: key);

  @override
  _CategoriesMainListPage createState() => _CategoriesMainListPage();
}

class _CategoriesMainListPage extends State<CategoriesMainListPage> {
  List categoryData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadCategoryData();
  }

  Future<void> loadCategoryData() async {
    try {
      final CategoriesService categoriesService = CategoriesService();

      final user = Provider.of<UserService>(context, listen: false);
      final groupId = user.currentGroupId;

      final data = await categoriesService.getCacheCategoryData(groupId);

      setState(() {
        categoryData = this.reorderCategoriesByUserCount([...data]);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      NotificationService.showError(
          context, "Erreur lors du chargement des données: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();

    return Scaffold(
        appBar: genericAppBar(
          appTitle: "Métiers du groupe",
          context: context,
        ),
        backgroundColor:
            FigmaColors.lightLight4, // Fond noir pour toute la page
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                    ),
                    physics:
                        const NeverScrollableScrollPhysics(), // Empêcher le GridView de défiler
                    shrinkWrap:
                        true, // Permettre au GridView de s'adapter à son contenu
                    itemCount: categoryData.length,
                    itemBuilder: (context, index) {
                      final category = categoryData[index];
                      final categoryName = category['name'];
                      final categoryID = category['id'];
                      //force category['users'] to be an int to avoid error when null (null is not a subtype of int)

                      final categoryUsers =
                          int.tryParse(category['users'].toString()) ?? 0;
                      final categoryId =
                          category['id']; // Récupérez l'ID de la catégorie

                      return InkWell(
                        onTap: categoryUsers > 0
                            ? () {
                                Navigator.of(context, rootNavigator: true)
                                    .pushNamed(
                                  RouteConstants.jobMainList,
                                  arguments: [categoryId],
                                );
                              }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            color: categoryUsers > 0
                                ? FigmaColors.lightLight3
                                : FigmaColors.lightLight0,
                            borderRadius:
                                BorderRadius.circular(12.0), // Coins arrondis
                            border: Border.all(
                              color: FigmaColors.lightLight2, // Bordure grise
                              width: 2.0, // Largeur de la bordure
                            ),
                          ),
                          // color: categoryUsers > 0 ? Colors.white : Colors.grey[200],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildCategoryIcon(categoryName, categoryID,
                                        categoryUsers),
                                    SizedBox(height: 10.0),
                                    Text(
                                      translationService
                                          .translate(categoryName),
                                      style: FigmaTextStyles()
                                          .stylizedBlockquote
                                          .copyWith(
                                            color: categoryUsers > 0
                                                ? FigmaColors.darkDark0
                                                : FigmaColors.darkDark3,
                                          ),
                                    ),
                                  ]),
                              Text(
                                '${categoryUsers} voisin${categoryUsers > 1 ? 's' : ''}',
                                style: FigmaTextStyles().body14pt.copyWith(
                                      color: categoryUsers > 0
                                          ? FigmaColors.darkDark2
                                          : FigmaColors.darkDark3,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ));
  }

  Widget _buildCategoryIcon(
      String categoryName, String categoryID, int categoryUsers) {
    return Container(
      width: 51,
      height: 51,
      decoration: BoxDecoration(
        color: categoryUsers > 0
            ? getColorByCategoryId(categoryID)
            : FigmaColors.lightLight1,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(
          IconsExtension.getIconData(categoryName),
          color: categoryUsers > 0 ? FigmaColors.lightLight4 : Colors.grey[400],
          size: 31,
        ),
      ),
    );
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
