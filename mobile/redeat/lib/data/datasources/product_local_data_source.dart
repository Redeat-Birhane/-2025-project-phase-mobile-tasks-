import '../../domain/entities/product.dart';

abstract class ProductLocalDataSource {
  Future<List<Product>> getCachedProducts();
  Future<void> cacheProduct(Product product);
  Future<void> updateCachedProduct(Product product);
  Future<void> removeCachedProduct(String id);
}