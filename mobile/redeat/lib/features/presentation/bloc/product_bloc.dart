import 'package:bloc/bloc.dart';
import '../../domain/usecases/get_all_products_usecase.dart';
import '../../domain/usecases/get_product_usecase.dart';
import '../../domain/usecases/insert_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetProductUseCase getProductUseCase;
  final InsertProductUseCase insertProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  ProductBloc({
    required this.getAllProductsUseCase,
    required this.getProductUseCase,
    required this.insertProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  }) : super(InitialState()) {
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<GetSingleProductEvent>(_onGetSingleProduct);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadAllProducts(
      LoadAllProductsEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    try {
      final failureOrProducts = await getAllProductsUseCase.call();
      failureOrProducts.fold(
            (failure) => emit(ErrorState(failure.toString())),
            (products) => emit(LoadedAllProductsState(products)),
      );
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onGetSingleProduct(
      GetSingleProductEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    try {
      final failureOrProduct = await getProductUseCase.call(event.productId);
      failureOrProduct.fold(
            (failure) => emit(ErrorState(failure.toString())),
            (product) => emit(LoadedSingleProductState(product)),
      );
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onCreateProduct(
      CreateProductEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    try {
      await insertProductUseCase.call(event.product);
      final failureOrProducts = await getAllProductsUseCase.call();
      failureOrProducts.fold(
            (failure) => emit(ErrorState(failure.toString())),
            (products) => emit(LoadedAllProductsState(products)),
      );
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
      UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    try {
      await updateProductUseCase.call(event.product);
      final failureOrProducts = await getAllProductsUseCase.call();
      failureOrProducts.fold(
            (failure) => emit(ErrorState(failure.toString())),
            (products) => emit(LoadedAllProductsState(products)),
      );
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
      DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    try {
      await deleteProductUseCase.call(event.productId);
      final failureOrProducts = await getAllProductsUseCase.call();
      failureOrProducts.fold(
            (failure) => emit(ErrorState(failure.toString())),
            (products) => emit(LoadedAllProductsState(products)),
      );
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
