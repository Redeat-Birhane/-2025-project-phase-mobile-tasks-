import '../entities/product.dart';

abstract class ProductRepository {
  Future<void> insertProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
  Future<Product?> getProduct(String id);
  Future<List<Product>> getAllProducts();
}
