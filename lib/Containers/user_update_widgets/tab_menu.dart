import 'package:flutter/material.dart';

Widget buildTabMenu(_selectedTabIndex, _onNavBarTapped) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        // Onglet Mes infos
        GestureDetector(
          onTap: () => _onNavBarTapped(0),
          child: Row(
            children: <Widget>[
              Icon(Icons.person,
                  color: _selectedTabIndex == 0 ? Colors.blue : Colors.black),
              const SizedBox(width: 10.0),
              Text(
                'MES INFOS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: _selectedTabIndex == 0
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedTabIndex == 0 ? Colors.blue : Colors.black,
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
                  color: _selectedTabIndex == 1 ? Colors.blue : Colors.black),
              const SizedBox(width: 10.0),
              Text(
                'MES JOBS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: _selectedTabIndex == 1
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedTabIndex == 1 ? Colors.blue : Colors.black,
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