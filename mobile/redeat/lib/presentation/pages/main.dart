import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_first_app/data/repositories/product_repository_impl.dart';
import 'package:my_first_app/domain/repositories/product_repository.dart';
import 'package:my_first_app/domain/usecases/create_product.dart';
import 'package:my_first_app/domain/usecases/delete_product.dart';
import 'package:my_first_app/domain/usecases/update_product.dart';
import 'package:my_first_app/domain/usecases/view_all_products.dart';
import 'package:my_first_app/domain/usecases/view_product.dart';
import 'package:my_first_app/presentation/pages/add.dart';
import 'package:my_first_app/presentation/pages/details.dart';
import 'package:my_first_app/presentation/pages/home.dart';
import 'package:my_first_app/presentation/pages/search.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/search_products.dart';
final ProductRepository productRepository = ProductRepositoryImpl();
final viewAllProductsUseCase = ViewAllProductsUseCase(productRepository);
final viewProductUseCase = ViewProductUseCase(productRepository);
final createProductUseCase = CreateProductUseCase(productRepository);
final updateProductUseCase = UpdateProductUseCase(productRepository);
final deleteProductUseCase = DeleteProductUseCase(productRepository);
final searchProductsUseCase = SearchProductsUseCase(productRepository);

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
      home: HomePage(
        viewAllProductsUseCase: viewAllProductsUseCase,
        deleteProductUseCase: deleteProductUseCase,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/add':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => AddUpdatePage(
                product: args?['product'] as Product?,
                onSave: args?['onSave'] as Function(Product)?,
              ),
            );
          case '/details':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => DetailsPage(
                product: args?['product'] as Product,
                onDelete: args?['onDelete'] as Function()?,
              ),
            );
          case '/search':
            return MaterialPageRoute(
              builder: (context) => SearchPage(
                searchProductsUseCase: searchProductsUseCase,
              ),
            );
          case '/home':
            return MaterialPageRoute(
              builder: (context) => HomePage(
                viewAllProductsUseCase: viewAllProductsUseCase,
                deleteProductUseCase: deleteProductUseCase,
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}