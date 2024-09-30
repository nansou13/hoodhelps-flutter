import 'package:hoodhelps/Containers/Modules/user_update/circle_avatar_update.dart';
import 'package:hoodhelps/Containers/Modules/user_update/tab_menu.dart';
import 'package:hoodhelps/Containers/Modules/user_update/user_info_tab.dart';
import 'package:hoodhelps/Containers/Modules/user_update/user_jobs_tab.dart';
import 'package:flutter/material.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  EditPageState createState() => EditPageState();
}

class EditPageState extends State<EditPage> {
  int _selectedTabIndex = 0;

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final translationService = context.read<TranslationService>();
    return Scaffold(
      backgroundColor: const Color(0xFF2CC394),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 35.0),
              const EditAvatar(),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    // padding: const EdgeInsets.only(top: 10),
                    children: [
                      const SizedBox(height: 20.0),
                      buildTabMenu(_selectedTabIndex, _onNavBarTapped,
                          translationService),
                      const SizedBox(height: 10.0),
                      _selectedTabIndex == 0
                          ? const EditUserInfoPage()
                          : const EditUserJobsPage(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            //Go back button
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
