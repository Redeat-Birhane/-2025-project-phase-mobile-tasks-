import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class InitialState extends ProductState {}

class LoadingState extends ProductState {}

class LoadedAllProductsState extends ProductState {
  final List<Product> products;

  const LoadedAllProductsState(this.products);

  @override
  List<Object?> get props => [products];
}

class LoadedSingleProductState extends ProductState {
  final Product product;

  const LoadedSingleProductState(this.product);

  @override
  List<Object?> get props => [product];
}

class ErrorState extends ProductState {
  final String message;

  const ErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
