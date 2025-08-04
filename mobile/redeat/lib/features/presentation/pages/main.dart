import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../presentation/pages/home.dart';
import '../../../presentation/pages/add.dart';
import '../../../presentation/pages/details.dart';
import '../../../domain/entities/product.dart';


void main() {
  runApp(ProductManagementApp());
}

class ProductManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      routes: {
        '/add': (context) => AddUpdatePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final product = settings.arguments as Product;
          return MaterialPageRoute(builder: (_) => DetailsPage(product: product));
        }
        return null;
      },
    );
  }
}
