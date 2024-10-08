import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:hoodhelps/Containers/user_account.dart';
import 'package:hoodhelps/Containers/user_account_groups.dart';
import 'package:hoodhelps/Containers/user_account_jobs.dart';
import 'package:hoodhelps/custom_colors.dart';
import 'package:hoodhelps/route_constants.dart';
import 'package:hoodhelps/services/api_service.dart';
import 'package:hoodhelps/services/jobs_provider.dart';
import 'package:hoodhelps/services/navigation_provider.dart';
import 'package:hoodhelps/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

// Containers
import 'package:hoodhelps/Containers/forgot_password.dart';
import 'package:hoodhelps/Containers/forgot_password_reset_code.dart';
import 'package:hoodhelps/Containers/forgot_password_reset_success.dart';
import 'package:hoodhelps/Containers/join_group.dart';
import 'package:hoodhelps/Containers/categories_main_list.dart';
import 'package:hoodhelps/Containers/lobby_page.dart';
import 'package:hoodhelps/Containers/login_page.dart';
import 'package:hoodhelps/Containers/register.dart';
import 'package:hoodhelps/Containers/register_login_page.dart';
import 'package:hoodhelps/Containers/splash_page.dart';
import 'package:hoodhelps/Containers/user_info.dart';
import 'package:hoodhelps/Containers/user_update.dart';
import 'package:hoodhelps/Containers/category_job_users_list.dart';
import 'package:hoodhelps/Containers/category_jobs_list.dart';
import 'package:hoodhelps/Containers/user_menu.dart';

// Services
import 'package:hoodhelps/services/translation_service.dart';
import 'package:hoodhelps/services/user_service.dart';
import 'package:hoodhelps/services/firebase_messaging_service.dart';

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
        ChangeNotifierProvider(create: (_) => JobsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  Future<void> _handleIncomingLinks() async {
    final userToken = await ApiService().getToken();
    // Pour gérer les liens universels (iOS) et les App Links (Android)
    try {
      final appLinks = AppLinks();
      appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          if (uri.pathSegments.contains('joingroup')) {
            final code = uri.queryParameters['code'];
            // check if user is logged
            if (code != null) {
            if(userToken != null && userToken.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(navigatorKey.currentContext!).pushNamed(
                  RouteConstants.joinGroup,
                  arguments: {'code': code},
                );
              });
            }else {
              // if user is not logged, save the code in shared preferences
              SharedPreferences.getInstance().then((prefs) {
                prefs.setString('joinGroupCode', code);
              });
            }
            }
          }
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print('Erreur lors de la gestion des liens entrants: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HoodHelps',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        colorSchemeSeed: FigmaColors.lightLight4,
        useMaterial3: true,
      ),
      initialRoute: RouteConstants.splash,
      routes: _buildAppRoutes(),
      navigatorKey: navigatorKey,
    );
  }

  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {
      RouteConstants.splash: (context) => const SplashScreen(),
      RouteConstants.login: (context) => const LoginPage(),
      RouteConstants.registerLogin: (context) => const RegisterLoginPage(),
      RouteConstants.lobby: (context) => const LobbyPage(),
      RouteConstants.userMenu: (context) => const UserMenu(),
      RouteConstants.userAccount: (context) => const UserAccount(),
      RouteConstants.userAccountGroups: (context) => const UserAccountGroups(),
      RouteConstants.userAccountJobs: (context) => const UserAccountJobs(),
      RouteConstants.jobMainList: (context) => const CategoryJobsMainListPage(),
      RouteConstants.categoriesMainList: (context) => const CategoriesMainListPage(),
      RouteConstants.userMainList: (context) => const CategoryJobUsersMainListPage(),
      RouteConstants.register: (context) => const RegisterPage(),
      RouteConstants.userInfo: (context) => const ProfilePage(),
      RouteConstants.editUser: (context) => const EditPage(),
      RouteConstants.joinGroup: (context) => const JoinGroup(),
      RouteConstants.forgotPassword: (context) => const ForgotPassword(),
      RouteConstants.forgotPasswordResetCode: (context) =>
          const ForgotPasswordResetCode(),
      RouteConstants.forgotPasswordResetSuccess: (context) =>
          const ForgotPasswordResetSuccess(),
    };
  }
}
