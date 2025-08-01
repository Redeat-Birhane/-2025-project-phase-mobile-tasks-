import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/features/product/data/models/product_model.dart';
import '../../domain/entities/product.dart';
import 'product_local_data_source.dart';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const cachedProductsKey = 'CACHED_PRODUCTS';
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Product>> getCachedProducts() async {
    final jsonString = sharedPreferences.getString(cachedProductsKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> decodedList = json.decode(jsonString);
      return decodedList
          .map<Product>((jsonProduct) => ProductModel.fromJson(jsonProduct))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> cacheProduct(Product product) async {
    final products = await getCachedProducts();
    products.add(product);
    final jsonString =
    json.encode(products.map((p) => (p as ProductModel).toJson()).toList());
    await sharedPreferences.setString(cachedProductsKey, jsonString);
  }

  @override
  Future<void> updateCachedProduct(Product product) async {
    final products = await getCachedProducts();
    final index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index] = product;
      final jsonString =
      json.encode(products.map((p) => (p as ProductModel).toJson()).toList());
      await sharedPreferences.setString(cachedProductsKey, jsonString);
    }
  }

  @override
  Future<void> removeCachedProduct(String id) async {
    final products = await getCachedProducts();
    products.removeWhere((p) => p.id == id);
    final jsonString =
    json.encode(products.map((p) => (p as ProductModel).toJson()).toList());
    await sharedPreferences.setString(cachedProductsKey, jsonString);
  }
}
