import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/template_two_blocks.dart';
import 'package:hoodhelps/Containers/Widgets/user_avatar_box.dart';
import 'package:hoodhelps/utils.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:provider/provider.dart';

class UserMenu extends StatefulWidget {
  const UserMenu({Key? key}) : super(key: key);

  @override
  _UserMenu createState() => _UserMenu();
}

class _UserMenu extends State<UserMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserService>(context, listen: false);
    final translationService = context.read<TranslationService>();

    return Scaffold(
      backgroundColor: FigmaColors.lightLight4,
      appBar: genericAppBar(
          context: context,
          appTitle: translationService
              .translate("MY_ACCOUNT")), // Fond noir pour toute la page
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              _buildUserProfile(context, user),
              SizedBox(height: 20),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: double.infinity,
                      child: SingleChildScrollView(
                          child: Container(
                              padding: const EdgeInsets.all(14.0),
                              decoration: BoxDecoration(
                                  color: FigmaColors.lightLight3,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  )),
                              child: Column(
                                children: [
                                  _buildMenuOption(
                                      context: context,
                                      icon: Icons.groups,
                                      text: 'Mes groupes',
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pushNamed(RouteConstants.userInfo);
                                      }),
                                  SizedBox(height: 14),
                                  Divider(
                                    color: FigmaColors.lightLight1,
                                    thickness: 1,
                                  ),
                                  SizedBox(height: 14),
                                  _buildMenuOption(
                                      context: context,
                                      icon: Icons.card_travel,
                                      text: 'Mes métiers',
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pushNamed(RouteConstants.userInfo);
                                      }),
                                ],
                              )))),
                  Container(
                      width: double.infinity,
                      child: SingleChildScrollView(
                          child: Container(
                              padding: const EdgeInsets.all(14.0),
                              decoration: BoxDecoration(
                                  color: FigmaColors.lightLight3,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  )),
                              child: Column(
                                children: [
                                  _buildMenuOption(
                                      context: context,
                                      icon: Icons.logout,
                                      text: 'Se déconnecter',
                                      iconColor: FigmaColors.redRed1,
                                      onTap: () {
                                        FunctionUtils.disconnectUser(context);
                                      }),
                                ],
                              )))),
                ],
              ))
            ],
          )),
    );
  }

  Widget _buildUserProfile(BuildContext context, UserService userService) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .pushNamed(RouteConstants.userAccount);
      },
      child:
    Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: FigmaColors.primaryPrimary1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          UserAvatarBox(user: userService, size: 72),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FunctionUtils.getUserName(userService),
                  style: FigmaTextStyles()
                      .headingsh5
                      .copyWith(color: FigmaColors.lightLight4),
                ),
                Text(
                  'Voir le profil',
                  style: FigmaTextStyles()
                      .body16pt
                      .copyWith(color: FigmaColors.lightLight4),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: FigmaColors.lightLight4),
        ],
      ),
    ),
    );
  }

  Widget _buildMenuOption({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? FigmaColors.darkDark4,
                size: 25,
              ),
              SizedBox(width: 10),
              Text(text,
                  style: FigmaTextStyles()
                      .body16pt
                      .copyWith(color: FigmaColors.darkDark0)),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: FigmaColors.darkDark0,
            size: 15,
          ),
        ],
      ),
    );
  }
}
