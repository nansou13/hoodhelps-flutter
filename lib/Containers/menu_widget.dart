import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/group_widget.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:hoodhelps/utils.dart';
import 'package:provider/provider.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translationService = Provider.of<TranslationService>(context, listen: false);
    final user = Provider.of<UserService>(context, listen: false);

    final String firstName = user.firstName ?? '';
    final String lastName = user.lastName ?? '';
    final String email = user.email ?? '';
    final String imageUrl = user.imageUrl ?? '';
    final String fullName = FunctionUtils.capitalizeFirstLetter('$firstName $lastName');
    final String initials = '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();

    final groups = user.groups;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(fullName),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              backgroundColor: Colors.blueGrey,
              child: Text(
                imageUrl.isEmpty ? initials : '',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, 
              children: [
                Flexible(
                  child: SingleChildScrollView(
          child:Column(
                children: [
          ...groups.map((group) {
            final name = group.name;
            final address = group.address;
            final cp = group.cp;
            final city = group.city;
            final backgroundUrl = group.backgroundUrl;
            return GroupCard(
              name: name,
              address: address,
              cp: cp,
              city: city,
              backgroundUrl: backgroundUrl,
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushNamed(RouteConstants.lobby, arguments: [group.id]);
              },
            );
          }).toList(),
                ],
        ),
                  ),
                ),
                _joinGroupCard(translationService, context),
              ],
            ),
          ),
          
          // const Spacer(),
          _parameterButton(translationService, context),
          _disconnectButton(translationService, context),
        ],
      ),
    );
  }

  Widget _joinGroupCard(TranslationService translationService, BuildContext context) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
                Navigator.of(context, rootNavigator: true).pushNamed(RouteConstants.joinGroup);
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
                color: Colors.blue,
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
    );
  }

  Widget _disconnectButton(TranslationService translationService, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: Text(translationService.translate('DISCONNECT_BUTTON')),
          onTap: () {
            FunctionUtils.disconnectUser(context);
          },
        ),
      ),
    );
  }
  Widget _parameterButton(TranslationService translationService, BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: ListTile(
          leading: const Icon(Icons.settings),
          title: Text(translationService.translate('PARAMETER_BUTTON')),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pushNamed(RouteConstants.editUser);
          },
        ),
    );
  }
}
