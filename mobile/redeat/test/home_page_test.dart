import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/home.dart';
import 'package:my_first_app/search.dart';

void main() {
  testWidgets('HomePage renders header correctly', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.text('Hello, Yohannes'), findsOneWidget);
    expect(find.text('Available Products'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('HomePage displays product list', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Derby Leather Shoes'), findsWidgets);
    expect(find.text('\$120'), findsWidgets);
  });

  testWidgets('Search icon navigates to search page', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const HomePage(),
      routes: {
        '/search': (context) => const SearchPage(),
      },
    ));

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.byType(SearchPage), findsOneWidget);
  });
}

