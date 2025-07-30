import '../repositories/product_repository.dart';
import '../entities/product.dart';
import 'usecase.dart';

class SearchProductsUseCase implements UseCase<List<Product>, SearchParams> {
  final ProductRepository repository;

  SearchProductsUseCase(this.repository);

  @override
  Future<List<Product>> call(SearchParams params) async {
    final allProducts = await repository.getAllProducts();
    return allProducts.where((product) {
      final matchesQuery = params.query.isEmpty ||
          product.name.toLowerCase().contains(params.query.toLowerCase());
      final matchesCategory = params.category.isEmpty ||
          product.category.toLowerCase() == params.category.toLowerCase();
      final matchesPrice = product.price >= params.minPrice &&
          product.price <= params.maxPrice;

      return matchesQuery && matchesCategory && matchesPrice;
    }).toList();
  }
}

class SearchParams {
  final String query;
  final String category;
  final double minPrice;
  final double maxPrice;

  SearchParams({
    required this.query,
    required this.category,
    required this.minPrice,
    required this.maxPrice,
  });
}