import 'package:flutter/material.dart';

Widget buildTabMenu(_selectedTabIndex, _onNavBarTapped, translationService) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      // Onglet Mes infos
      GestureDetector(
        onTap: () => _onNavBarTapped(0),
        child: Row(
          children: <Widget>[
            Icon(Icons.person,
                color:
                    _selectedTabIndex == 0 ? Color(0xFF2CC394) : Colors.black),
            const SizedBox(width: 10.0),
            Text(
              translationService.translate('TAB_MENU_MY_INFOS'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: _selectedTabIndex == 0
                    ? FontWeight.bold
                    : FontWeight.normal,
                color:
                    _selectedTabIndex == 0 ? Color(0xFF2CC394) : Colors.black,
                decoration: _selectedTabIndex == 0
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
      // Onglet Mes jobs
      GestureDetector(
        onTap: () => _onNavBarTapped(1),
        child: Row(
          children: <Widget>[
            Icon(Icons.work,
                color:
                    _selectedTabIndex == 1 ? Color(0xFF2CC394) : Colors.black),
            const SizedBox(width: 10.0),
            Text(
              translationService.translate('TAB_MENU_MY_JOBS'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: _selectedTabIndex == 1
                    ? FontWeight.bold
                    : FontWeight.normal,
                color:
                    _selectedTabIndex == 1 ? Color(0xFF2CC394) : Colors.black,
                decoration: _selectedTabIndex == 1
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
