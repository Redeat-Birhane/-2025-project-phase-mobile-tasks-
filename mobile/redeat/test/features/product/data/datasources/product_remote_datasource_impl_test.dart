import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:my_first_app/core/features/product/data/models/product_model.dart';
import 'package:my_first_app/data/datasources/product_remote_datasource_impl.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = ProductRemoteDataSourceImpl(client: mockHttpClient);
  });

  final productJson = {
    "id": "1",
    "name": "Test Product",
    "description": "Description",
    "price": 10,
    "imageUrl": "http://test.com/image.png"
  };

  final productModel = ProductModel.fromJson(productJson);
  final productListJson = {
    "statusCode": 200,
    "message": "",
    "data": [productJson]
  };

  group('fetchAllProducts', () {
    test('returns list of products when response is 200', () async {
      when(mockHttpClient.get(Uri.parse('${ProductRemoteDataSourceImpl.baseUrl}/products')))
          .thenAnswer((_) async => http.Response(json.encode(productListJson), 200));

      final result = await dataSource.fetchAllProducts();

      expect(result, isA<List<ProductModel>>());
      expect(result.length, 1);
      expect(result.first.id, productModel.id);
    });

    test('throws exception when response is not 200', () {
      when(mockHttpClient.get(Uri.parse('${ProductRemoteDataSourceImpl.baseUrl}/products')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(dataSource.fetchAllProducts(), throwsException);
    });
  });


}
