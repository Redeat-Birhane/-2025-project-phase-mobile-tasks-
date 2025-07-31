import '../../domain/entities/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> fetchAllProducts();
  Future<Product?> fetchProductById(String id);
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}