import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_first_app/core/error/exceptions.dart';
import 'package:my_first_app/core/error/failures.dart';
import 'package:my_first_app/core/platform/network_info.dart';
import 'package:my_first_app/features/domain/entities/product.dart';
import 'package:my_first_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:my_first_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:my_first_app/features/product/data/repositories/product_repository_impl.dart';


class MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}

class MockLocalDataSource extends Mock implements ProductLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'Description',
    imageUrl: 'http://image.url',
    price: 99.99,
  );

  final tProductList = [tProduct];

  group('getAllProducts', () {
    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllProducts())
          .thenAnswer((_) async => tProductList);

      await repository.getAllProducts();

      verify(mockNetworkInfo.isConnected);
    });

    test('should return remote data when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllProducts())
          .thenAnswer((_) async => tProductList);
      when(mockLocalDataSource.cacheProducts(tProductList))
          .thenAnswer((_) async => Future.value());

      final result = await repository.getAllProducts();

      verify(mockRemoteDataSource.getAllProducts());
      verify(mockLocalDataSource.cacheProducts(tProductList));
      expect(result, Right(tProductList));
    });

    test('should return cached data when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getCachedProducts())
          .thenAnswer((_) async => tProductList);

      final result = await repository.getAllProducts();

      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getCachedProducts());
      expect(result, Right(tProductList));
    });

    test('should return CacheFailure when no cached data available', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getCachedProducts()).thenThrow(CacheException());

      final result = await repository.getAllProducts();

      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getCachedProducts());
      expect(result, Left(CacheFailure()));
    });
  });

}
