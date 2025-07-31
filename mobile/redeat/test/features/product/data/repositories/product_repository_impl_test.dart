import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_first_app/data/repositories/product_repository_impl.dart';
import 'package:my_first_app/domain/entities/product.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemoteDataSource;
  late MockProductLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

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

  final testProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'Description',
    price: 10.0,
    imageUrl: 'http://image.url',
  );

  group('getAllProducts', () {
    test('should return remote data when network is connected', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.fetchAllProducts()).thenAnswer((_) async => [testProduct]);

      final result = await repository.getAllProducts();

      expect(result, [testProduct]);
      verify(mockRemoteDataSource.fetchAllProducts()).called(1);
      verify(mockLocalDataSource.cacheProduct(testProduct)).called(1);
    });

    test('should return local data when network is disconnected', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getCachedProducts()).thenAnswer((_) async => [testProduct]);

      final result = await repository.getAllProducts();

      expect(result, [testProduct]);
      verify(mockLocalDataSource.getCachedProducts()).called(1);
    });
  });

  group('insertProduct', () {
    test('should insert product when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      await repository.insertProduct(testProduct);

      verify(mockRemoteDataSource.addProduct(testProduct)).called(1);
      verify(mockLocalDataSource.cacheProduct(testProduct)).called(1);
    });

    test('should throw exception when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      expect(() => repository.insertProduct(testProduct), throwsException);
    });
  });


}
