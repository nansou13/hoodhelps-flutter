import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/template_connected_page.dart';
// import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  _UsersPage createState() => _UsersPage();
}

class _UsersPage extends State<EventsPage> {
  String appBarTitle = 'Evenements';

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
      child: Text('Events Page'),
    );
  }
}
