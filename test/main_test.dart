import 'package:flutter_test/flutter_test.dart';
import 'package:hoodhelps/main.dart';
import 'package:hoodhelps/Containers/splash_page.dart';

void main() {
  testWidgets('MyApp widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(SplashScreen), findsOneWidget);

    // Testez d'autres aspects du widget MyApp ici
  });

  testWidgets('Route test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Exemple de test pour la route SplashScreen
    expect(find.byType(SplashScreen), findsOneWidget);

    // Vous pouvez ajouter des tests pour les autres routes ici
  });
}
