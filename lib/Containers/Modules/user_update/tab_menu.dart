import 'package:flutter/material.dart';

Widget buildTabMenu(selectedTabIndex, onNavBarTapped, translationService) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      // Onglet Mes infos
      GestureDetector(
        onTap: () => onNavBarTapped(0),
        child: Row(
          children: <Widget>[
            Icon(Icons.person,
                color:
                    selectedTabIndex == 0 ? const Color(0xFF2CC394) : Colors.black),
            const SizedBox(width: 10.0),
            Text(
              translationService.translate('TAB_MENU_MY_INFOS'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: selectedTabIndex == 0
                    ? FontWeight.bold
                    : FontWeight.normal,
                color:
                    selectedTabIndex == 0 ? const Color(0xFF2CC394) : Colors.black,
                decoration: selectedTabIndex == 0
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
      // Onglet Mes jobs
      GestureDetector(
        onTap: () => onNavBarTapped(1),
        child: Row(
          children: <Widget>[
            Icon(Icons.work,
                color:
                    selectedTabIndex == 1 ? const Color(0xFF2CC394) : Colors.black),
            const SizedBox(width: 10.0),
            Text(
              translationService.translate('TAB_MENU_MY_JOBS'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: selectedTabIndex == 1
                    ? FontWeight.bold
                    : FontWeight.normal,
                color:
                    selectedTabIndex == 1 ? const Color(0xFF2CC394) : Colors.black,
                decoration: selectedTabIndex == 1
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
