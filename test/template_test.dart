import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hoodhelps/template.dart';

void main() {
  testWidgets('background returns a correctly configured Image widget', (WidgetTester tester) async {
    // Créez le widget en utilisant votre fonction background
    Widget testWidget = MaterialApp(home: Scaffold(body: background()));

    // Attachez le widget au test
    await tester.pumpWidget(testWidget);

    // Recherchez le widget Image dans l'arborescence des widgets
    final image = tester.widget<Image>(find.byType(Image));

    // Vérifiez que l'image a les propriétés attendues
    expect(image.image, isA<AssetImage>());
    expect(image.fit, BoxFit.cover);
    expect(image.width, double.infinity);
    expect(image.height, double.infinity);

    // Vérifiez que le chemin de l'image est correct
    AssetImage assetImage = image.image as AssetImage;
    expect(assetImage.assetName, 'assets/background_image.jpg');
  });
}
