import '../../domain/entities/product.dart';

class SearchController {
  final List<Product> allProducts;

  SearchController({required this.allProducts});

  List<Product> filter({
    String query = '',
    String category = '',
    double minPrice = 0,
    double maxPrice = 200,
  }) {
    final q = query.toLowerCase();

    return allProducts.where((product) {
      final name = product.name.toLowerCase();
      final matchesQuery = q.isEmpty || name.contains(q);
      final matchesCategory = category.isEmpty || product.name.toLowerCase().contains(category.toLowerCase());
      final matchesPrice = product.price >= minPrice && product.price <= maxPrice;

      return matchesQuery && matchesCategory && matchesPrice;
    }).toList();
  }
}
