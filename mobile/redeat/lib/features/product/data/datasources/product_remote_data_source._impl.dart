import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/entities/product.dart';
import '../models/product_model.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getAllProducts(String token);
  Future<Product> getProductById(String id, String token);
  Future<Product> addProduct(Product product, String token, {required String imagePath});
  Future<Product> updateProduct(Product product, String token);
  Future<void> deleteProduct(String id, String token);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Product>> getAllProducts(String token) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrlV2}/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final productsJson = jsonMap['data'] as List;
      return productsJson.map((p) => ProductModel.fromJson(p)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Product> getProductById(String id, String token) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrlV2}/products/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final productJson = jsonMap['data'];
      return ProductModel.fromJson(productJson);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Product> addProduct(Product product, String token, {required String imagePath}) async {
    var uri = Uri.parse('${ApiConstants.baseUrlV2}/products');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = product.name;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toString();
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final jsonMap = json.decode(response.body);
      return ProductModel.fromJson(jsonMap['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Product> updateProduct(Product product, String token) async {
    final response = await client.put(
      Uri.parse('${ApiConstants.baseUrlV2}/products/${product.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
      }),
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return ProductModel.fromJson(jsonMap['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(String id, String token) async {
    final response = await client.delete(
      Uri.parse('${ApiConstants.baseUrlV2}/products/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }
}
