import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:my_first_app/features/domain/entities/product.dart';
import 'package:my_first_app/features/domain/repositories/product_repository.dart';
import 'package:my_first_app/features/domain/usecases/insert_product_usecase.dart';
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late InsertProductUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = InsertProductUseCase(mockRepository);
  });

  final tProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    price: 99.99,
    imageUrl: 'http://test.com/image.jpg',
  );

  test('should insert product using repository', () async {
    // arrange
    when(mockRepository.createProduct(tProduct))
        .thenAnswer((_) async => Right(null));

    // act
    final result = await useCase.call(tProduct);

    // assert
    expect(result, Right(null));
    verify(mockRepository.createProduct(tProduct));
    verifyNoMoreInteractions(mockRepository);
  });
}
