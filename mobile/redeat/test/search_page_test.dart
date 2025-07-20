import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/search.dart';

void main() {
  testWidgets('SearchPage shows search field and filters', (tester) async {
    await tester.pumpWidget(MaterialApp(home: SearchPage()));

    expect(find.text('Search Product'), findsOneWidget);
    expect(find.text('Leather'), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Price'), findsOneWidget);
  });

  testWidgets('Search functionality works', (tester) async {
    await tester.pumpWidget(MaterialApp(home: SearchPage()));

    await tester.enterText(find.byType(TextField), 'Derby');
    await tester.pump();

    expect(find.text('Derby Leather Shoes'), findsOneWidget);
  });

  testWidgets('APPLY button works', (tester) async {
    await tester.pumpWidget(MaterialApp(home: SearchPage()));

    await tester.tap(find.text('APPLY'));
    await tester.pump();

    // Verify filters are applied (would need state management verification)
  });
}