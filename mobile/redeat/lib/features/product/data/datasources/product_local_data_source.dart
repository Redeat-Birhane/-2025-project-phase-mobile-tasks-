import '../../../domain/entities/product.dart';

abstract class ProductLocalDataSource {
  Future<List<Product>> getCachedProducts();
  Future<Product?> getCachedProductById(String id);
  Future<void> cacheProduct(Product product);
  Future<void> updateCachedProduct(Product product);
  Future<void> deleteCachedProduct(String id);
}
