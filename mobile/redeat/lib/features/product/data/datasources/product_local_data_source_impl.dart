import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../domain/entities/product.dart';
import '../utils/product_utils.dart';
import 'product_local_data_source.dart';

const cachedProductsKey = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProducts(List<Product> products) {
    final productJsonList = products.map((product) => productToMap(product)).toList();
    return sharedPreferences.setString(cachedProductsKey, json.encode(productJsonList));
  }

  @override
  Future<List<Product>> getCachedProducts() {
    final jsonString = sharedPreferences.getString(cachedProductsKey);

    if (jsonString != null) {
      final List<dynamic> decodedJson = json.decode(jsonString);
      return Future.value(jsonListToProductList(decodedJson));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<Product> getCachedProduct(String id) async {
    final jsonString = sharedPreferences.getString(cachedProductsKey);

    if (jsonString != null) {
      final List<dynamic> decodedJson = json.decode(jsonString);
      final products = jsonListToProductList(decodedJson);

      try {
        final product = products.firstWhere((product) => product.id == id);
        return Future.value(product);
      } catch (_) {
        throw CacheException(); // Product not found
      }
    } else {
      throw CacheException(); // No cache exists
    }
  }
}
