import 'package:flutter/material.dart';
import '../domain/entities/product.dart';
import 'pages/add.dart';
import 'pages/home.dart';
import 'pages/details.dart';

void main() {
  runApp(ProductManagementApp());
}

class ProductManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      routes: {
        '/add': (context) => AddUpdatePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final product = settings.arguments as dynamic;
          if (product is Product) {
            return MaterialPageRoute(builder: (_) => DetailsPage(product: product));
          }
        }
        return null;
      },
    );
  }
}
