import '../entities/product.dart';

abstract class ProductRepository {
  Future<void> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
  Future<Product?> getProductById(String id);
  Future<List<Product>> getAllProducts();
}
