import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/Widgets/avatar_stack.dart';
import 'package:hoodhelps/Containers/Widgets/button_widget.dart';
import 'package:hoodhelps/Containers/Widgets/user_list_display_widget.dart';
import 'package:hoodhelps/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:provider/provider.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key? key}) : super(key: key);

  @override
  _LobbyPage createState() => _LobbyPage();
}

class _LobbyPage extends State<LobbyPage> {
  @override
  void initState() {
    super.initState();
  }

  final PageController _pageController = PageController();

  String getUserName(UserService user) {
    return FunctionUtils.capitalizeFirstLetter(
        user.firstName?.isNotEmpty ?? false ? user.firstName! : user.username!);
  }

  // user.setCurrentGroupId(group.id);
  void _onGroupChanged(int index) {
    final user = Provider.of<UserService>(context, listen: false);
    final groups = user.groups;

    if (index < groups.length) {
      if (groups[index].id.isNotEmpty) {
        setState(() {
          user.setCurrentGroupId(groups[index].id);
        });
      }
    }
  }

  Group? getGroupById(String groupId, List<Group> groups) {
    try {
      return groups.firstWhere((group) => group.id == groupId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserService>(context, listen: false);
    final translationService = context.read<TranslationService>();
    final groups = user.groups;
    var groupId = user.currentGroupId;
    Group? specificGroup =
        getGroupById(groupId, groups); // Obtenir le groupId mis à jour

    return Scaffold(
      backgroundColor: FigmaColors.darkDark0,// Fond noir pour toute la page
      body: Stack(
        children: [
          // Image en arrière-plan en haut
          _buildBackgroundImage(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30), // Espace en haut
              _buildLobbyTop(context, getUserName(user)),

              if (groupId != '') _buildGroupCarousel(groups),
              if (groupId != '') SizedBox(height: 10),
              if (groupId != '') _buildPagination(groups.length + 1),

              SizedBox(height: 10),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: FigmaColors.lightLight4,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0),
                    ),
                  ),
                  child: groupId == ''
                      ? _buildNoGroupContent(translationService)
                      : _buildGroupContent(specificGroup!, translationService),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroupBlock(Group group) {
    final users = buildUserAvatarList(group.users);
    return _buildMainGroupBlock(
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
                    .copyWith(color: FigmaColors.lightLight4),
                maxLines: 1, // Limite à 2 lignes
                overflow:
                    TextOverflow.ellipsis, // Affiche "..." si le texte dépasse
              ),
            ),
            // SizedBox(width: 50),
            // Icon(Icons.ac_unit, color: color, size: 40),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AvatarStack(users: users),
            ),
            Text("${group.users.length} membres",
                style: FigmaTextStyles()
                    .body14pt
                    .copyWith(color: FigmaColors.lightLight4)),
          ],
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Text('Code : ${group.code.toUpperCase()}',
                  style: FigmaTextStyles()
                      .body14pt
                      .copyWith(color: FigmaColors.lightLight4)),
              SizedBox(width: 10),
              Icon(
                Icons.share,
                color: FigmaColors.lightLight4,
                size: 18,
              ),
            ]),
          ],
        ),
      ],
    ));
  }

  Widget _buildNewBlock() {
    final translationService = context.read<TranslationService>();
    return _buildMainGroupBlock(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed(RouteConstants.joinGroup);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add,
                    size: 30.0,
                    color: FigmaColors.lightLight4,
                  ),
                  SizedBox(width: 10),
                  Text(
                    translationService.translate('JOIN_A_GROUP'),
                    style: FigmaTextStyles()
                        .stylizedMedium
                        .copyWith(color: FigmaColors.lightLight4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainGroupBlock({required Widget child}) {
    return Container(
        // padding: EdgeInsets.all(16.0), // Respecte les marges entre les pages
        margin: EdgeInsets.all(10.0), // Respecte les marges entre les pages
        decoration: BoxDecoration(
          color: FigmaColors.darkDark0
              .withOpacity(0.7), // Fond noir avec 70% d'opacité
          borderRadius: BorderRadius.circular(18.0), // Coins arrondis
          border: Border.all(
            color: FigmaColors.darkDark2, // Bordure grise
            width: 2.0, // Largeur de la bordure
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: child,
        ));
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

  Widget _buildBackgroundImage() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Image.asset(
        'assets/home_background.png',
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _buildLobbyTop(BuildContext context, String userName) {
    final user = Provider.of<UserService>(context, listen: false);
    final jobs = user.jobs;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bonjour $userName',
            style: FigmaTextStyles().headingsh1.copyWith(
                  color: FigmaColors.lightLight4,
                ),
          ),
          _buildProfileIcon(context, hasNotification: jobs.length == 0),
        ],
      ),
    );
  }

  Widget _buildProfileIcon(BuildContext context, {bool hasNotification = true}) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context, rootNavigator: true)
          .pushNamed(RouteConstants.userMenu);
    },
    child: Stack(
      clipBehavior: Clip.none, // Permet d'afficher la notification hors du Container si besoin
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: FigmaColors.darkDark1,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
        if (hasNotification) // Ajout de la condition pour afficher ou non la notification
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 12, // Taille du cercle rouge
              height: 12,
              decoration: BoxDecoration(
                color: FigmaColors.primaryPrimary0, // Couleur du cercle
                shape: BoxShape.circle, // Forme du badge
              ),
            ),
          ),
      ],
    ),
  );
}

  Widget _buildGroupCarousel(List<Group> groups) {
    return SizedBox(
      height: 170,
      child: PageView(
        controller: _pageController,
        onPageChanged: _onGroupChanged,
        physics: BouncingScrollPhysics(),
        children: [
          ...groups.map((group) => _buildGroupBlock(group)).toList(),
          _buildNewBlock()
        ],
      ),
    );
  }

  Widget _buildPagination(int count) {
    return Center(
      child: SmoothPageIndicator(
        controller: _pageController,
        count: count,
        effect: WormEffect(
          dotHeight: 10,
          dotWidth: 10,
          spacing: 16,
          dotColor: FigmaColors.lightLight4.withOpacity(0.4),
          activeDotColor: FigmaColors.lightLight4,
        ),
      ),
    );
  }

  Widget _buildNoGroupContent(TranslationService translationService) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 34.0),
          Image.asset(
            'assets/join_group_transparent.png',
            fit: BoxFit.cover,
            width: 205,
          ),
          const SizedBox(height: 22.0),
          Text(
            translationService.translate('NOT_IN_A_GROUP_MESSAGE'),
            style: FigmaTextStyles()
                .body16pt
                .copyWith(color: FigmaColors.darkDark2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 27.0),
          buildButton(
            variant: "tertiary",
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(RouteConstants.joinGroup);
            },
            text: translationService.translate('JOIN_A_GROUP'),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupContent(
      Group group, TranslationService translationService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: Text(
            group.name,
            style: FigmaTextStyles().stylizedMedium.copyWith(
                  color: FigmaColors.darkDark0,
                ),
          ),
        ),
        SizedBox(height: 13),
        buildButton(
          variant: "tertiary",
          text: translationService.translate('FIND_PRO'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed(RouteConstants.categoriesMainList);
          },
        ),
        SizedBox(height: 13),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: group.users
                  .map((user) => UserListDisplay(user: user))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
