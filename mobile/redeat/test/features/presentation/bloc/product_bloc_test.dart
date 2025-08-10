import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_first_app/core/error/failures.dart';
import 'package:my_first_app/features/domain/entities/product.dart';
import 'package:my_first_app/features/domain/usecases/delete_product_usecase.dart';
import 'package:my_first_app/features/domain/usecases/get_all_products_usecase.dart';
import 'package:my_first_app/features/domain/usecases/get_product_usecase.dart';
import 'package:my_first_app/features/domain/usecases/insert_product_usecase.dart';
import 'package:my_first_app/features/domain/usecases/update_product_usecase.dart';
import 'package:my_first_app/features/presentation/bloc/product_bloc.dart';
import 'package:my_first_app/features/presentation/bloc/product_event.dart';
import 'package:my_first_app/features/presentation/bloc/product_state.dart';

class MockGetAllProductsUseCase extends Mock implements GetAllProductsUseCase {}
class MockGetProductUseCase extends Mock implements GetProductUseCase {}
class MockInsertProductUseCase extends Mock implements InsertProductUseCase {}
class MockUpdateProductUseCase extends Mock implements UpdateProductUseCase {}
class MockDeleteProductUseCase extends Mock implements DeleteProductUseCase {}

void main() {
  late ProductBloc productBloc;
  late MockGetAllProductsUseCase mockGetAllProductsUseCase;
  late MockGetProductUseCase mockGetProductUseCase;
  late MockInsertProductUseCase mockInsertProductUseCase;
  late MockUpdateProductUseCase mockUpdateProductUseCase;
  late MockDeleteProductUseCase mockDeleteProductUseCase;

  final testProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    imageUrl: 'http://test.com/image.png',
    price: 99.99,
  );

  final List<Product> testProductList = [testProduct];

  setUp(() {
    mockGetAllProductsUseCase = MockGetAllProductsUseCase();
    mockGetProductUseCase = MockGetProductUseCase();
    mockInsertProductUseCase = MockInsertProductUseCase();
    mockUpdateProductUseCase = MockUpdateProductUseCase();
    mockDeleteProductUseCase = MockDeleteProductUseCase();

    productBloc = ProductBloc(
      getAllProductsUseCase: mockGetAllProductsUseCase,
      getProductUseCase: mockGetProductUseCase,
      insertProductUseCase: mockInsertProductUseCase,
      updateProductUseCase: mockUpdateProductUseCase,
      deleteProductUseCase: mockDeleteProductUseCase,
    );
  });

  test('initial state should be InitialState', () {
    expect(productBloc.state, equals(InitialState()));
  });

  blocTest<ProductBloc, ProductState>(
    'emits [LoadingState, LoadedAllProductsState] when LoadAllProductsEvent is added and data is loaded successfully',
    build: () {
      when(() => mockGetAllProductsUseCase.call())
          .thenAnswer((_) async => Right(testProductList));
      return productBloc;
    },
    act: (bloc) => bloc.add(LoadAllProductsEvent()),
    expect: () => [
      LoadingState(),
      LoadedAllProductsState(testProductList),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [LoadingState, ErrorState] when LoadAllProductsEvent is added and data loading fails',
    build: () {
      when(() => mockGetAllProductsUseCase.call())
          .thenAnswer((_) async => Left(ServerFailure()));  // Use Failure here
      return productBloc;
    },
    act: (bloc) => bloc.add(LoadAllProductsEvent()),
    expect: () => [
      LoadingState(),
      isA<ErrorState>(),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [LoadingState, LoadedSingleProductState] when GetSingleProductEvent is added and product is loaded successfully',
    build: () {
      when(() => mockGetProductUseCase.call('1'))
          .thenAnswer((_) async => Right(testProduct));
      return productBloc;
    },
    act: (bloc) => bloc.add(GetSingleProductEvent('1')),
    expect: () => [
      LoadingState(),
      LoadedSingleProductState(testProduct),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [LoadingState, ErrorState] when GetSingleProductEvent fails',
    build: () {
      when(() => mockGetProductUseCase.call('1'))
          .thenAnswer((_) async => Left(ServerFailure()));
      return productBloc;
    },
    act: (bloc) => bloc.add(GetSingleProductEvent('1')),
    expect: () => [
      LoadingState(),
      isA<ErrorState>(),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [LoadingState, LoadedAllProductsState] after successful CreateProductEvent',
    build: () {
      when(() => mockInsertProductUseCase.call(testProduct))
          .thenAnswer((_) async => Future.value());
      when(() => mockGetAllProductsUseCase.call())
          .thenAnswer((_) async => Right(testProductList));
      return productBloc;
    },
    act: (bloc) => bloc.add(CreateProductEvent(testProduct)),
    expect: () => [
      LoadingState(),
      LoadedAllProductsState(testProductList),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [LoadingState, ErrorState] when CreateProductEvent fails',
    build: () {
      when(() => mockInsertProductUseCase.call(testProduct))
          .thenThrow(Exception('Create Failed'));
      return productBloc;
    },
    act: (bloc) => bloc.add(CreateProductEvent(testProduct)),
    expect: () => [
      LoadingState(),
      isA<ErrorState>(),
    ],
  );


}
