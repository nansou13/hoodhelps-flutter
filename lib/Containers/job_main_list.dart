import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Modules/jobs/job_category_display_grid.dart';
import 'package:hoodhelps/Containers/template_connected_page.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/Containers/Modules/jobs/Job_display.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:provider/provider.dart';

class JobMainListPage extends StatefulWidget {
  const JobMainListPage({Key? key}) : super(key: key);

  @override
  _JobMainListPage createState() => _JobMainListPage();
}

class _JobMainListPage extends State<JobMainListPage> {
  bool isLoading =
      true; // Ajoutez une variable pour gérer l'affichage du loader
  String appBarTitle = 'Liste des métiers';

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
    final user = Provider.of<UserService>(context, listen: false);

    final List<dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>?;
    var groupId = user.currentGroupId;
    var categoryId = '';

    if (arguments != null && arguments.isNotEmpty) {
      categoryId = arguments[0].toString();
    }

    return ConnectedPage(
      showBottomNav: groupId != '',
      showLeading: categoryId.isNotEmpty,
      appTitle: appBarTitle,
      child: groupId == ''
          ? _buildNoGroupContent()
          : categoryId.isNotEmpty
              ? JobCategoryDisplayGrid(
                  groupId: groupId,
                  categoryId: categoryId,
                  updateTitleCallback: updateAppBarTitle,
                )
              : JobDisplay(updateTitleCallback: updateAppBarTitle),
    );
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
