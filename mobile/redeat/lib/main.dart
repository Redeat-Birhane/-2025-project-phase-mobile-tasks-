import 'package:flutter/material.dart';
import 'add.dart';
import 'details.dart';
import 'home.dart';
import 'search.dart';

void main() {
  runApp(const ProductManagementApp());
}

class ProductManagementApp extends StatelessWidget {
  const ProductManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/add':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => AddUpdatePage(
                product: args?['product'],
                onSave: args?['onSave'],
              ),
            );
          case '/details':
            final args = settings.arguments as Map<String, dynamic>?;
            final product = args?['product'] as Map<String, dynamic>? ?? {};
            final onDelete = args?['onDelete'] as Function()?;
            return MaterialPageRoute(
              builder: (context) => DetailsPage(
                product: product,
                onDelete: onDelete,
              ),
            );
          case '/search':
            return MaterialPageRoute(builder: (context) => const SearchPage());
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomePage());
          default:
            return null; // Unknown route
        }
      },
    );
  }
}
