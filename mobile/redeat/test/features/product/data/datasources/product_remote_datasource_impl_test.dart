import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_first_app/core/features/product/data/models/product_model.dart';
import 'package:my_first_app/data/datasources/product_local_data_source_impl.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ProductLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  final productModel = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'Description',
    price: 10.0,
    imageUrl: 'http://test.com/image.png',
  );

  final productList = [productModel];
  final jsonString = json.encode(productList.map((product) => product.toJson()).toList());

  group('getCachedProducts', () {
    test('should return list of products from SharedPreferences', () async {
      when(mockSharedPreferences.getString('CACHED_PRODUCTS')).thenReturn(jsonString);

      final result = await dataSource.getCachedProducts();

      expect(result.length, 1);
      expect(result.first.id, '1');
      verify(mockSharedPreferences.getString('CACHED_PRODUCTS')).called(1);
    });

    test('should return empty list when no data is cached', () async {
      when(mockSharedPreferences.getString('CACHED_PRODUCTS')).thenReturn(null);

      final result = await dataSource.getCachedProducts();

      expect(result, []);
      verify(mockSharedPreferences.getString('CACHED_PRODUCTS')).called(1);
    });
  });

  group('cacheProduct', () {
    test('should save product to SharedPreferences', () async {
      when(mockSharedPreferences.getString('CACHED_PRODUCTS')).thenReturn(null);
      final encoded = json.encode([productModel.toJson()]);
      when(mockSharedPreferences.setString('CACHED_PRODUCTS', encoded)).thenAnswer((_) async => true);

      await dataSource.cacheProduct(productModel);

      verify(mockSharedPreferences.setString('CACHED_PRODUCTS', encoded)).called(1);
    });
  });

  group('updateCachedProduct', () {
    test('should update product in cached list', () async {
      final updatedProduct = productModel.copyWith(name: 'Updated Name');
      final updatedJson = json.encode([updatedProduct.toJson()]);

      when(mockSharedPreferences.getString('CACHED_PRODUCTS')).thenReturn(jsonString);
      when(mockSharedPreferences.setString('CACHED_PRODUCTS', updatedJson)).thenAnswer((_) async => true);

      await dataSource.updateCachedProduct(updatedProduct);

      verify(mockSharedPreferences.setString('CACHED_PRODUCTS', updatedJson)).called(1);
    });
  });

  group('removeCachedProduct', () {
    test('should remove product from cached list', () async {
      when(mockSharedPreferences.getString('CACHED_PRODUCTS')).thenReturn(jsonString);
      when(mockSharedPreferences.setString('CACHED_PRODUCTS', '[]')).thenAnswer((_) async => true);

      await dataSource.removeCachedProduct('1');

      verify(mockSharedPreferences.setString('CACHED_PRODUCTS', '[]')).called(1);
    });
  });
}
