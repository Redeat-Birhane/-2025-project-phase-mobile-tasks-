import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/add.dart';

void main() {
  testWidgets('AddUpdatePage shows form fields and button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddUpdatePage()));

    expect(find.text('Add Product'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.widgetWithText(ElevatedButton, 'Add Product'), findsOneWidget);
  });

  testWidgets('Form validation shows errors on empty submit', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddUpdatePage()));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Product'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a name'), findsOneWidget);
    expect(find.text('Please enter a price'), findsOneWidget);
    expect(find.text('Please enter a category'), findsOneWidget);
  });

  testWidgets('Tap on image picker container triggers image pick', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddUpdatePage()));

    final imagePickerFinder = find.byType(GestureDetector).first;
    expect(imagePickerFinder, findsOneWidget);

    await tester.tap(imagePickerFinder);
    await tester.pump();
  });
}
