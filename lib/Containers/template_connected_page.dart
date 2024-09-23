import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/ads_page.dart';
import 'package:hoodhelps/Containers/events_page.dart';
import 'package:hoodhelps/Containers/categories_main_list.dart';
import 'package:hoodhelps/Containers/category_job_users_list.dart';
import 'package:hoodhelps/Containers/lobby_page.dart';
import 'package:hoodhelps/Containers/Widgets/menu_widget.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/navigation_provider.dart';
import 'package:provider/provider.dart';

class ConnectedPage extends StatefulWidget {
  final Widget child;
  final bool showBottomNav;
  final bool showAppBar;
  final bool showLeading;
  final String appTitle;
  const ConnectedPage(
      {Key? key,
      required this.child,
      this.showBottomNav = true,
      this.showLeading = true,
      this.appTitle = 'Home',
      this.showAppBar = true})
      : super(key: key);

  @override
  _ConnectedPageState createState() => _ConnectedPageState();
}

class _ConnectedPageState extends State<ConnectedPage> {
  void _onItemTapped(int index) {
    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    navigationProvider.setSelectedIndex(index);
    String route;
    switch (index) {
      case 0:
        route = RouteConstants.lobby;
        break;
      case 1:
        route = RouteConstants.jobMainList;

        break;
      case 2:
        route = RouteConstants.userMainList;
        break;
      case 3:
        route = RouteConstants.eventPage;
        break;
      case 4:
        route = RouteConstants.adsPage;
        break;
      default:
        route = RouteConstants.lobby;
    }
    Navigator.of(context, rootNavigator: true)
        .pushReplacement(_createRoute(route));
    // pushReplacementNamed
    // RouteConstants.userInfo,
    //                 arguments: [user['id'], job[0], job[1], groupId],
  }

  Route _createRoute(String route) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => _getPage(route),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child; // Pas de transition animée
      },
    );
  }

  Widget _getPage(String route) {
    switch (route) {
      case RouteConstants.lobby:
        return LobbyPage();
      case RouteConstants.jobMainList:
        return CategoriesMainListPage();
      case RouteConstants.userMainList:
        return CategoryJobUsersMainListPage();
      case RouteConstants.eventPage:
        return EventsPage();
      case RouteConstants.adsPage:
        return AdsPage();
      default:
        return LobbyPage(); // Page par défaut
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    var _selectedIndex = navigationProvider.selectedIndex;
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              toolbarHeight: 40.0,
              leading: widget.showLeading
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : null,
              title: Text(widget.appTitle),
              centerTitle: false,
              titleTextStyle: TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            )
          : null,
      drawer: const MenuWidget(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          color: Color(0xFFF2F2F2),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(  // Ajout du SingleChildScrollView ici
            child: widget.child,
          ),
        ),
      ),
      bottomNavigationBar: widget.showBottomNav
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, -2), // changes position of shadow
                  ),
                ],
              ),
              height: 110, // Adjust the height as needed
              child: BottomNavigationBar(
                elevation: 4.0,
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: Color(0xFF2CC394),
                unselectedItemColor: Colors.grey[400],
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.maps_home_work_outlined, size: 40),
                    label: 'Lobby',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.work_outline_rounded, size: 40),
                    label: 'Métiers',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_alt_outlined, size: 40),
                    label: 'Voisins',
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.event, size: 36),
                  //   label: 'Evenements',
                  // ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.announcement, size: 36),
                  //   label: 'Annonces',
                  // ),
                ],
                selectedLabelStyle:
                    TextStyle(fontSize: 14), // Adjust the label size
                unselectedLabelStyle: TextStyle(fontSize: 12),
              ),
            )
          : null,
    );
  }
}
