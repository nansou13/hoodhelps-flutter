// firebase_messaging_service.dart
// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initFirebaseMessaging() async {
    // Demander l'autorisation
    NotificationSettings settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Écouter les messages en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message en premier plan: ${message.data}');
      if (message.notification != null) {
        print('Notification: ${message.notification}');
      }
    });

    // Gestion des messages en arrière-plan
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String?> getToken() async {
    try {
      String? token = await _messaging.getToken();
      return token;
    } catch (e) {
      print('Erreur lors de la récupération du token FCM: $e');
      return null;
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}
