import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../datasources/product_local_data_source.dart';
import '../../core/network/network_info.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      final remoteProducts = await remoteDataSource.fetchAllProducts();
      for (var product in remoteProducts) {
        await localDataSource.cacheProduct(product);
      }
      return remoteProducts;
    } else {
      return await localDataSource.getCachedProducts();
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    if (await networkInfo.isConnected) {
      final product = await remoteDataSource.fetchProductById(id);
      if (product != null) {
        await localDataSource.updateCachedProduct(product);
      }
      return product;
    } else {
      final products = await localDataSource.getCachedProducts();
      try {
        return products.firstWhere((p) => p.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Future<void> insertProduct(Product product) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.addProduct(product);
      await localDataSource.cacheProduct(product);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.updateProduct(product);
      await localDataSource.updateCachedProduct(product);
    } else {
      throw Exception("No internet connection");
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    if (await networkInfo.isConnected) {
      await remoteDataSource.deleteProduct(id);
      await localDataSource.removeCachedProduct(id);
    } else {
      throw Exception("No internet connection");
    }
  }
}
