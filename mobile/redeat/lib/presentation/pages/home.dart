import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/helpers.dart';
import '../../data/datasources/product_local_data_source_impl.dart';
import '../../data/datasources/product_remote_datasource_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/ get_all_products_usecase.dart';
import '../../domain/usecases/insert_product_usecase.dart';
import '../../data/repositories/product_repository_impl.dart';

import '../widgets/product_card.dart';
import 'add.dart';
import 'details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final GetAllProductsUsecase _getAllProductsUsecase;
  late final InsertProductUsecase _insertProductUsecase;

  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeDependenciesAndLoadProducts();
  }

  Future<void> _initializeDependenciesAndLoadProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final localDataSource = ProductLocalDataSourceImpl(sharedPreferences: prefs);
      final remoteDataSource = ProductRemoteDataSourceImpl(client: http.Client());
      final repository = ProductRepositoryImpl(
        localDataSource: localDataSource,
        remoteDataSource: remoteDataSource,
      );

      _getAllProductsUsecase = GetAllProductsUsecase(repository);
      _insertProductUsecase = InsertProductUsecase(repository);

      await _loadProducts();
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _getAllProductsUsecase.call();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddUpdatePage()),
    );

    if (result is Product) {
      await _insertProductUsecase.call(result);
      await _loadProducts();
    }
  }

  void _navigateToDetails(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailsPage(product: product)),
    );

    if (result != null && result is Product) {
      await _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Available Products')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? const Center(child: Text('No products found.'))
          : Padding(
        padding: EdgeInsets.all(mobile ? 8 : 16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: mobile ? 1 : 2,
            childAspectRatio: mobile ? 1.5 : 1.8,
            crossAxisSpacing: mobile ? 8 : 16,
            mainAxisSpacing: mobile ? 8 : 16,
          ),
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return GestureDetector(
              onTap: () => _navigateToDetails(product),
              child: ProductCard(product: product),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
