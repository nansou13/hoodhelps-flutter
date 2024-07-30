import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/template_connected_page.dart';
// import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:provider/provider.dart';

class AdsPage extends StatefulWidget {
  const AdsPage({Key? key}) : super(key: key);

  @override
  _AdsPage createState() => _AdsPage();
}

class _AdsPage extends State<AdsPage> {
  String appBarTitle = 'Annonces';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final translationService = context.read<TranslationService>();
    final user = Provider.of<UserService>(context, listen: false);
    var groupId = user.currentGroupId;

    return ConnectedPage(
      showLeading: false,
      showBottomNav: groupId != '',
      appTitle: appBarTitle,
      child: Text('Ads Page'),
    );
  }
}
