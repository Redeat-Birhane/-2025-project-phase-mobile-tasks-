import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/details.dart';

void main() {
  testWidgets('DetailsPage shows product information', (tester) async {
    await tester.pumpWidget(MaterialApp(home: DetailsPage(product: {},)));

    expect(find.text("Men's shoe"), findsOneWidget);
    expect(find.text('(4.0)'), findsOneWidget);
    expect(find.text('Derby Leather'), findsOneWidget);
    expect(find.text('\$120'), findsOneWidget);
  });

  testWidgets('DetailsPage shows size options', (tester) async {
    await tester.pumpWidget(MaterialApp(home: DetailsPage(product: {},)));

    expect(find.text('Size:'), findsOneWidget);
    expect(find.text('39'), findsOneWidget);
    expect(find.text('44'), findsOneWidget);
  });

  testWidgets('DELETE button shows confirmation dialog', (tester) async {
    await tester.pumpWidget(MaterialApp(home: DetailsPage(product: {},)));

    await tester.tap(find.text('DELETE'));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Are you sure?'), findsOneWidget);
  });
}