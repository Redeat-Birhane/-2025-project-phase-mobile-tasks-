import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/add.dart';

void main() {
  testWidgets('AddUpdatePage shows form fields', (tester) async {
    await tester.pumpWidget(MaterialApp(home: AddUpdatePage()));

    expect(find.text('Add Product'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(4));
    expect(find.text('ADD'), findsOneWidget);
  });

  testWidgets('Form validation works', (tester) async {
    await tester.pumpWidget(MaterialApp(home: AddUpdatePage()));

    // Try to submit empty form
    await tester.tap(find.text('ADD'));
    await tester.pump();

    expect(find.text('Please enter a name'), findsOneWidget);
    expect(find.text('Please enter a category'), findsOneWidget);
  });

  testWidgets('Image upload button works', (tester) async {
    await tester.pumpWidget( MaterialApp(home: AddUpdatePage()));

    await tester.tap(find.text('upload image'));
    await tester.pump();

    // Verify image picker was called (would need mocks for full implementation)
  });
}