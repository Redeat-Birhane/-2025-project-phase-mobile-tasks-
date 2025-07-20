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
      title: 'Product Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
        //'/details': (context) => DetailsPage(product: {}),
        '/add': (context) => AddUpdatePage(),
        '/search': (context) => SearchPage(),
      },
    );
  }
}