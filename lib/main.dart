// Dart imports
import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/events_page.dart';
import 'package:hoodhelps/Containers/job_main_list.dart';
import 'package:hoodhelps/Containers/users_list.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/navigation_provider.dart';

// Package imports
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

// Container imports
import 'package:hoodhelps/Containers/forgot_password.dart';
import 'package:hoodhelps/Containers/forgot_password_reset_code.dart';
import 'package:hoodhelps/Containers/forgot_password_reset_success.dart';
import 'package:hoodhelps/Containers/join_group.dart';
import 'package:hoodhelps/Containers/user_info.dart';
import 'package:hoodhelps/Containers/user_update.dart';
import 'package:hoodhelps/Containers/job_users.dart';
import 'package:hoodhelps/Containers/lobby_page.dart';
import 'package:hoodhelps/Containers/login_page.dart';
import 'package:hoodhelps/Containers/register.dart';
import 'package:hoodhelps/Containers/splash_page.dart';

// Local imports
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:hoodhelps/services/firebase_messaging_service.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  // Assurez-vous que les widgets Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Initialisez les préférences partagées
  await SharedPreferences.getInstance();

  // Initialisez les langs
  var translationService = TranslationService();
  await translationService.loadTranslations("fr");

  // Initialisez Firebase
  await Firebase.initializeApp();

  // Initialisez le service FCM
  var firebaseMessagingService = FirebaseMessagingService();
  await firebaseMessagingService.initFirebaseMessaging();

  runApp(
    MultiProvider(
      providers: [
        Provider<UserService>(create: (_) => UserService()),
        Provider<TranslationService>.value(value: translationService),
        Provider<NavigationProvider>(create: (_) => NavigationProvider()),
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
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        colorSchemeSeed: const Color(0xFF2CC394),
        useMaterial3: true,
      ),
      initialRoute: RouteConstants.splash,
      routes: {
        RouteConstants.splash: (context) => const SplashScreen(),
        RouteConstants.login: (context) => const LoginPage(),
        RouteConstants.lobby: (context) => const LobbyPage(),
        RouteConstants.jobMainList: (context) => const JobMainListPage(),
        RouteConstants.userMainList: (context) => const UsersList(),
        RouteConstants.register: (context) => const RegisterPage(),
        RouteConstants.userList: (context) => const JobUsers(),
        RouteConstants.userInfo: (context) => const ProfilePage(),
        RouteConstants.editUser: (context) => const EditPage(),
        RouteConstants.joinGroup: (context) => const JoinGroup(),
        RouteConstants.forgotPassword: (context) => const ForgotPassword(),
        RouteConstants.forgotPasswordResetCode: (context) =>
            const ForgotPasswordResetCode(),
        RouteConstants.forgotPasswordResetSuccess: (context) =>
            const ForgotPasswordResetSuccess(),
        RouteConstants.eventPage: (context) => const EventsPage(),
      },
    );
  }
}
