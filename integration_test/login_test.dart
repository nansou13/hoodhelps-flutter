import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hoodhelps/Containers/lobby_page.dart';
import 'package:hoodhelps/Containers/login_page.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hoodhelps/main.dart' as app; // Remplacez par le chemin correct vers votre fichier main.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login Page Test', (WidgetTester tester) async {
    // Lancez votre application
    app.main();
    await tester.pumpAndSettle();

    // Assurez-vous que vous êtes sur la page de connexion
    expect(find.byType(LoginPage), findsOneWidget);

    // Remplissez les champs de texte pour le nom d'utilisateur et le mot de passe
    await tester.enterText(find.byKey(Key('usernameField')), 'nansou');
    await tester.enterText(find.byKey(Key('passwordField')), 'coucou');

    // Appuyez sur le bouton de connexion
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pumpAndSettle();

    // Vérifiez que la navigation a eu lieu après la connexion
    expect(find.byType(LobbyPage), findsOneWidget);
  });
}
