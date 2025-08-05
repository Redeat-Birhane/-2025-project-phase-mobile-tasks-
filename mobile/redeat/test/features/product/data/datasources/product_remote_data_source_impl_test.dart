import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/core/constants/api_constants.dart';
import 'package:my_first_app/core/error/exceptions.dart';
import 'package:my_first_app/features/domain/entities/product.dart';
import 'package:my_first_app/features/product/data/datasources/product_remote_data_source._impl.dart';
import 'package:my_first_app/features/product/data/utils/product_utils.dart';


class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = ProductRemoteDataSourceImpl(client: mockHttpClient);
  });

  final tProduct = Product(
    id: '123',
    name: 'Test Product',
    description: 'Description',
    price: 9.99,
    imageUrl: 'http://example.com/image.png',
  );

  final tProductJson = productToMap(tProduct);

  final tProductsJsonList = [tProductJson];
  final tProductsResponseJson = json.encode({
    'statusCode': 200,
    'message': '',
    'data': tProductsJsonList,
  });

  group('getAllProducts', () {
    test('should perform a GET request and return list of products on success', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('${ApiConstants.baseUrl}/products')))
          .thenAnswer((_) async => http.Response(tProductsResponseJson, 200));
      // act
      final result = await dataSource.getAllProducts();
      // assert
      expect(result, isA<List<Product>>());
      expect(result.length, 1);
      expect(result.first, tProduct);
    });

    test('should throw ServerException on non-200 response', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('${ApiConstants.baseUrl}/products')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = dataSource.getAllProducts;
      // assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
