import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_first_app/core/features/product/data/models/product_model.dart';
import 'package:my_first_app/data/datasources/product_local_data_source.dart';
import 'package:my_first_app/data/datasources/product_remote_data_source.dart';
import 'package:my_first_app/data/repositories/product_repository_impl.dart';
import 'package:my_first_app/domain/entities/product.dart';
import 'package:my_first_app/core/network/network_info.dart';


class MockProductRemoteDataSource extends Mock implements ProductRemoteDataSource {}
class MockProductLocalDataSource extends Mock implements ProductLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemoteDataSource;
  late MockProductLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  final testProduct = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'Description',
    price: 10.0,
    imageUrl: 'http://test.com/image.png',
  );

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    mockLocalDataSource = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getAllProducts', () {
    test('should fetch from remote and cache locally when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.fetchAllProducts()).thenAnswer((_) async => [testProduct]);
      when(mockLocalDataSource.cacheProduct(testProduct)).thenAnswer((_) async => Future.value());

      final result = await repository.getAllProducts();

      expect(result, [testProduct]);
      verify(mockRemoteDataSource.fetchAllProducts()).called(1);
      verify(mockLocalDataSource.cacheProduct(testProduct)).called(1);
    });

    test('should fetch from local when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getCachedProducts()).thenAnswer((_) async => [testProduct]);

      final result = await repository.getAllProducts();

      expect(result, [testProduct]);
      verify(mockLocalDataSource.getCachedProducts()).called(1);
      verifyNever(mockRemoteDataSource.fetchAllProducts());
    });
  });

  group('insertProduct', () {
    test('should insert product when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.addProduct(testProduct)).thenAnswer((_) async => Future.value());
      when(mockLocalDataSource.cacheProduct(testProduct)).thenAnswer((_) async => Future.value());

      await repository.insertProduct(testProduct);

      verify(mockRemoteDataSource.addProduct(testProduct)).called(1);
      verify(mockLocalDataSource.cacheProduct(testProduct)).called(1);
    });

    test('should throw exception when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      expect(() => repository.insertProduct(testProduct), throwsException);

      verifyNever(mockRemoteDataSource.addProduct(testProduct));
      verifyNever(mockLocalDataSource.cacheProduct(testProduct));
    });
  });


}
