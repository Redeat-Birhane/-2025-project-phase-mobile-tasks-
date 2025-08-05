import 'package:flutter/material.dart';
import 'features/presentation/pages/add.dart';
import 'features/presentation/pages/details.dart';
import 'features/presentation/pages/home.dart';
import 'features/presentation/pages/search.dart';


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
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          final product = args['product'] as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => AddUpdatePage(
              product: product,
            ),
          );
        }

        if (settings.name == '/details') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          final product = args['product'] as Map<String, dynamic>? ?? {};
          final onDelete = args['onDelete'] as Function()?;
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

        return null;
      },
    );
  }
}
