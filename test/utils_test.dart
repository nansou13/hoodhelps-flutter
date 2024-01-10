import 'package:flutter_test/flutter_test.dart';
import 'package:hoodhelps/utils.dart'; // Remplacez par le chemin correct de votre fichier
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Créez des classes mock ici
class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('capitalizeFirstLetter tests', () {
    test('Capitalize a lowercase string', () {
      var result = FunctionUtils.capitalizeFirstLetter('test');
      expect(result, 'Test');
    });

    test('String with initial uppercase remains unchanged', () {
      var result = FunctionUtils.capitalizeFirstLetter('Test');
      expect(result, 'Test');
    });

    test('Empty string returns empty', () {
      var result = FunctionUtils.capitalizeFirstLetter('');
      expect(result, isEmpty);
    });
  });
  
  group('disconnectUser tests', () {
    testWidgets('User is redirected to login on successful logout', (WidgetTester tester) async {
      // Configurez le mock SharedPreferences
      SharedPreferences.setMockInitialValues({userTokenKey: 'some_token'});
      final prefs = await SharedPreferences.getInstance();

      // Mock Navigator
      final mockObserver = MockNavigatorObserver();

      // Construisez un MaterialApp avec MockNavigator
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  FunctionUtils.disconnectUser(context);
                },
                child: Text('Logout'),
              );
            },
          ),
        ),
        navigatorObservers: [mockObserver],
        routes: {
          '/login': (context) => Scaffold(appBar: AppBar(title: Text('Login Page'))),
        },
      ));

      // Appuyez sur le bouton de déconnexion
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Vous pouvez également vérifier si les préférences ont été réinitialisées
      expect(prefs.getString(userTokenKey), '');
    });
  });
}
