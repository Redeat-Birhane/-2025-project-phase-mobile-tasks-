import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../domain/entities/product.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Product>> getAllProducts() async {
    final response = await client.get(Uri.parse('${ApiConstants.baseUrl}/products'));

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      final List<dynamic> productsJson = decodedJson['data'];
      return productsJson.map((jsonItem) => _mapToProduct(jsonItem)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Product> getProduct(String id) async {
    final response = await client.get(Uri.parse('${ApiConstants.baseUrl}/products/$id'));

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      final productJson = decodedJson['data'];
      return _mapToProduct(productJson);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(_productToMap(product)),
    );

    if (response.statusCode != 201) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    final response = await client.put(
      Uri.parse('${ApiConstants.baseUrl}/products/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(_productToMap(product)),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response = await client.delete(Uri.parse('${ApiConstants.baseUrl}/products/$id'));

    if (response.statusCode != 200) {
      throw ServerException();
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

  Product _mapToProduct(dynamic json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
