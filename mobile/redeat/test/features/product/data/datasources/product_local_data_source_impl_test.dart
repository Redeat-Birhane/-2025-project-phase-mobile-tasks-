import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_first_app/core/error/exceptions.dart';
import 'package:my_first_app/features/domain/entities/product.dart';
import 'package:my_first_app/features/product/data/datasources/product_local_data_source_impl.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ProductLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  final tProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'Description',
    imageUrl: 'http://example.com/image.png',
    price: 99.99,
  );

  final tProductList = [tProduct];
  final tProductJsonList = tProductList.map((p) {
    return json.encode({
      'id': p.id,
      'name': p.name,
      'description': p.description,
      'imageUrl': p.imageUrl,
      'price': p.price,
    });
  }).toList();

  group('cacheProducts', () {
    test('should call SharedPreferences to cache the list of products', () async {
      // arrange
      when(mockSharedPreferences.setStringList(
        'CACHED_PRODUCTS',
        tProductJsonList,
      )).thenAnswer((_) async => true);

      // act
      await dataSource.cacheProducts(tProductList);

      // assert
      verify(mockSharedPreferences.setStringList(
        'CACHED_PRODUCTS',
        tProductJsonList,
      ));
    });
  });

  group('getCachedProducts', () {
    test('should return list of products from SharedPreferences when there is cached data', () async {
      // arrange
      when(mockSharedPreferences.getStringList('CACHED_PRODUCTS'))
          .thenReturn(tProductJsonList);

      // act
      final result = await dataSource.getCachedProducts();

      // assert
      expect(result, equals(tProductList));
    });

    test('should throw CacheException when there is no cached data', () async {
      // arrange
      when(mockSharedPreferences.getStringList('CACHED_PRODUCTS'))
          .thenReturn(null);

      // act
      final call = dataSource.getCachedProducts;

      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('getCachedProduct', () {
    test('should return product when found in cache', () async {
      // arrange
      when(mockSharedPreferences.getStringList('CACHED_PRODUCTS'))
          .thenReturn(tProductJsonList);

      // act
      final result = await dataSource.getCachedProduct('1');

      // assert
      expect(result, equals(tProduct));
    });

    test('should throw CacheException when product is not found', () async {
      // arrange
      when(mockSharedPreferences.getStringList('CACHED_PRODUCTS'))
          .thenReturn(tProductJsonList);

      // act
      final call = () => dataSource.getCachedProduct('2');

      // assert
      expect(call, throwsA(isA<CacheException>()));
    });
  });
}
