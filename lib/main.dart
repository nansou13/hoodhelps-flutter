// Dart imports
import 'package:flutter/material.dart';

// Package imports
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Local imports
import 'package:hoodhelps/Containers/job_users.dart';
import 'package:hoodhelps/Containers/lobby_page.dart';
import 'package:hoodhelps/Containers/login_page.dart';
import 'package:hoodhelps/Containers/register.dart';
import 'package:hoodhelps/Containers/splash_page.dart';
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';

Future<void> main() async {
  // Assurez-vous que les widgets Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisez les préférences partagées
  await SharedPreferences.getInstance();

  // Initialisez les langs
  var translationService = TranslationService();
  await translationService.loadTranslations("fr");

  runApp(
    MultiProvider(
      providers: [
        Provider<UserService>(create: (_) => UserService()),
        Provider<TranslationService>.value(value: translationService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HoodHelps',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/lobby': (context) => const LobbyPage(),
        '/register': (context) => const RegisterPage(),
        '/userlist': (context) => const JobUsers(),
      },
    );
  }
}
