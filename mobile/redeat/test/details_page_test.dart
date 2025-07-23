import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/details.dart';

void main() {
  final testProduct = {
    'category': "Men's shoe",
    'rating': 4.0,
    'name': 'Derby Leather',
    'price': 120,
    'sizes': [39, 40, 41, 42, 43, 44],
    'description': 'Classic derby shoes',
    'image': 'assets/images/shoe.jpg',
    'id': '1',
  };

  testWidgets('DetailsPage shows product information', (tester) async {
    await tester.pumpWidget(MaterialApp(home: DetailsPage(product: testProduct)));

    expect(find.text("Men's shoe"), findsOneWidget);
    expect(find.text('(4.0)'), findsOneWidget);
    expect(find.text('Derby Leather'), findsOneWidget);
    expect(find.text('\$120'), findsOneWidget);
  });

  testWidgets('DetailsPage shows size options', (tester) async {
    await tester.pumpWidget(MaterialApp(home: DetailsPage(product: testProduct)));

    expect(find.text('Size:'), findsOneWidget);
    expect(find.text('39'), findsOneWidget);
    expect(find.text('44'), findsOneWidget);
  });

  testWidgets('DELETE button shows confirmation dialog', (tester) async {
    bool deletedCalled = false;

    await tester.pumpWidget(MaterialApp(
      home: DetailsPage(
        product: testProduct,
        onDelete: () {
          deletedCalled = true;
        },
      ),
    ));

    await tester.tap(find.text('DELETE'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Are you sure you want to delete this product?'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'DELETE'));
    await tester.pumpAndSettle();

    expect(deletedCalled, isTrue);
  });
}
