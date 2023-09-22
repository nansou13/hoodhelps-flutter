import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/loginPage.dart'; // Importez la classe HomePage
import 'package:hoodhelps/Containers/register.dart'; // Importez la classe HomePage
import 'package:hoodhelps/Containers/lobbyPage.dart'; // Importez la classe HomePage
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assurez-vous que les widgets Flutter sont initialisés

  // Initialisez les préférences partagées
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Route initiale de l'application
      routes: {
        '/': (context) => const LoginPage(), // Route par défaut (page d'accueil)
        '/lobby': (context) => LobbyPage(), // Exemple de route vers une page de profil
        '/register': (context) => RegisterPage(), // Exemple de route vers une page de paramètres
      },
    );
  }
}

