// Dart imports
import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/forgot_password.dart';
import 'package:hoodhelps/Containers/forgot_password_reset_code.dart';
import 'package:hoodhelps/Containers/forgot_password_reset_success.dart';
import 'package:hoodhelps/Containers/join_group.dart';
import 'package:hoodhelps/Containers/user_info.dart';
import 'package:hoodhelps/Containers/user_update.dart';

// Package imports
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

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

  // Initialisez Firebase
  await Firebase.initializeApp();

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
      // initialRoute: '/userinfo',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/lobby': (context) => const LobbyPage(),
        '/register': (context) => const RegisterPage(),
        '/userlist': (context) => const JobUsers(),
        '/userinfo': (context) => const ProfilePage(),
        '/userupdate': (context) => const EditPage(),
        '/joingroup': (context) => const JoinGroup(),
        '/forgotpassword': (context) => const ForgotPassword(),
        '/forgotpasswordresetcode': (context) => const ForgotPasswordResetCode(),
        '/forgotpasswordresetsuccess': (context) => const ForgotPasswordResetSuccess(),
      },
    );
  }
}
