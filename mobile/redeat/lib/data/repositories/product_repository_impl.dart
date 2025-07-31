import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../datasources/product_local_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      final remoteProducts = await remoteDataSource.fetchAllProducts();
      // Cache the fetched products locally
      for (var product in remoteProducts) {
        await localDataSource.cacheProduct(product);
      }
      return remoteProducts;
    } catch (e) {
      // On failure, return cached products
      return await localDataSource.getCachedProducts();
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      final remoteProduct = await remoteDataSource.fetchProductById(id);
      if (remoteProduct != null) {
        await localDataSource.updateCachedProduct(remoteProduct);
      }
      return remoteProduct;
    } catch (e) {
      // Fallback to cached product
      final cachedProducts = await localDataSource.getCachedProducts();
      try {
        return cachedProducts.firstWhere((p) => p.id == id);
      } catch (e) {
        // No product found, return null safely
        return null;
      }
    }
  }

  @override
  Future<void> insertProduct(Product product) async {
    await remoteDataSource.addProduct(product);
    await localDataSource.cacheProduct(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    await remoteDataSource.updateProduct(product);
    await localDataSource.updateCachedProduct(product);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await remoteDataSource.deleteProduct(id);
    await localDataSource.removeCachedProduct(id);
  }
}
