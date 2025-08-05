import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../../domain/entities/product.dart';
import 'product_local_data_source.dart';

const CACHED_PRODUCTS = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProducts(List<Product> products) {
    final productListJson =
    products.map((product) => json.encode(_productToMap(product))).toList();
    return sharedPreferences.setStringList(CACHED_PRODUCTS, productListJson);
  }

  @override
  Future<List<Product>> getCachedProducts() {
    final jsonStringList = sharedPreferences.getStringList(CACHED_PRODUCTS);
    if (jsonStringList == null || jsonStringList.isEmpty) {
      throw CacheException();
    } else {
      final products = jsonStringList
          .map((productJson) =>
          _mapToProduct(json.decode(productJson) as Map<String, dynamic>))
          .toList();
      return Future.value(products);
    }
  }

  @override
  Future<Product> getCachedProduct(String id) async {
    final products = await getCachedProducts();
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      throw CacheException();
    }
  }

  Map<String, dynamic> _productToMap(Product product) {
    return {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
    };
  }

  Product _mapToProduct(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      price: (map['price'] as num).toDouble(),
    );
  }
}
