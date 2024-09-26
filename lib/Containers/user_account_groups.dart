import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/avatar_stack.dart';
import 'package:hoodhelps/Containers/Widgets/button_widget.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/api_service.dart';
import 'package:hoodhelps/services/notifications_service.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:hoodhelps/utils.dart';
import 'package:provider/provider.dart';

class UserAccountGroups extends StatefulWidget {
  const UserAccountGroups({Key? key}) : super(key: key);

  @override
  _UserAccountGroupsState createState() => _UserAccountGroupsState();
}

class _UserAccountGroupsState extends State<UserAccountGroups> {
  bool isMiniLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserService>(context, listen: false);
    final translationService = context.read<TranslationService>();
    final groups = user.groups;
    return Scaffold(
      backgroundColor: FigmaColors.lightLight4,
      appBar: genericAppBar(
          context: context, appTitle: 'Mes groupes'), // Background color
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...groups
                    .map((group) => _buildGroupBlock(context, group))
                    .toList(),
                SizedBox(height: 25),
                buildButton(
                    text: translationService.translate('JOIN_A_GROUP'),
                    onPressed: () {
                      Navigator.pushNamed(context, RouteConstants.joinGroup);
                    }),
              ],
            ),
          )),
      // Text('user data ${user}')
    );
  }

  Widget _buildGroupBlock(BuildContext context, Group group) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: EdgeInsets.only(bottom: 12.0),
      alignment: Alignment.topLeft,
      width: double.infinity,
      decoration: BoxDecoration(
        color: FigmaColors.lightLight3,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: FigmaColors.lightLight2,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  group.name,
                  style: FigmaTextStyles()
                      .stylizedMedium
                      .copyWith(color: FigmaColors.darkDark0),
                  maxLines: 1, // Limite à 2 lignes
                  overflow: TextOverflow
                      .ellipsis, // Affiche "..." si le texte dépasse
                ),
              ),
              SizedBox(width: 50),
              IconButton(
                  onPressed: () async {
                    await deleteGroup(group.id);
                  },
                  icon: Icon(Icons.delete,
                      color: FigmaColors.darkDark0, size: 20))
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AvatarStack(
                  users: buildUserAvatarList(group.users),
                  TextColor: FigmaColors.darkDark2,
                ),
              ),
              Text("${group.users.length} membres",
                  style: FigmaTextStyles()
                      .body14pt
                      .copyWith(color: FigmaColors.darkDark0)),
            ],
          ),
        ],
      ),
    );
  }

  List<UserAvatar> buildUserAvatarList(List<dynamic> users) {
    return users.map((user) {
      // Récupère le nom complet ou utilise le username si first_name est null ou vide
      String image = user['image_url'] ?? '';
      final name = FunctionUtils.getUserName(user);

      // Crée l'objet UserAvatar
      return UserAvatar(
        name: name,
        image: image, // Si tu as un lien pour l'image, remplace ici
      );
    }).toList();
  }

  Future<void> deleteGroup(groupID) async {
    final user = Provider.of<UserService>(context, listen: false);
    setState(() {
      isMiniLoading = true;
    });

    try {
      final response = await ApiService()
          .delete('/users/me/group/$groupID', useToken: true, context: context);

      if (response.statusCode == 204) {
        // Si la requête réussit (statut 200), analyser la réponse JSON

        NotificationService.showInfo(
            context, 'Suppression effectuée avec succès');

        user.removeUserGroup(groupID);
      } else {
        // En cas d'échec de la requête, afficher un message d'erreur
        NotificationService.showError(context, 'Échec de la suppression');
      }
    } catch (e) {
      // En cas d'erreur lors de la requête
      NotificationService.showError(context, 'Erreur: $e');
    }
    setState(() {
      isMiniLoading = false;
    });
  }
}
