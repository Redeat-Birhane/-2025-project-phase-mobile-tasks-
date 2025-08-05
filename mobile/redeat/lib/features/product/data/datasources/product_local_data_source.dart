import '../../../domain/entities/product.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<Product> products);
  Future<List<Product>> getCachedProducts();

  Future<Product> getCachedProduct(String id);
}
