import 'package:flutter/material.dart';
import 'add.dart';
import 'details.dart';
import 'home.dart';
import 'search.dart';

void main() {
  runApp(ProductManagementApp());
}

class ProductManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      onGenerateRoute: (settings) {
        if (settings.name == '/add') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => AddUpdatePage(
              product: args?['product'],
              onSave: args?['onSave'],
            ),
          );
        }

        if (settings.name == '/details') {
          final args = settings.arguments as Map<String, dynamic>?;
          final product = args?['product'] as Map<String, dynamic>? ?? {};
          final onDelete = args?['onDelete'] as Function()?;
          return MaterialPageRoute(
            builder: (context) => DetailsPage(
              product: product,
              onDelete: onDelete,
            ),
          );
        }

        if (settings.name == '/search') {
          return MaterialPageRoute(builder: (context) => SearchPage());
        }

        if (settings.name == '/home') {
          return MaterialPageRoute(builder: (context) => HomePage());
        }

        return null; // Unknown route
      },
    );
  }
}
