import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllProductsEvent extends ProductEvent {}

class GetSingleProductEvent extends ProductEvent {
  final String productId;

  const GetSingleProductEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class CreateProductEvent extends ProductEvent {
  final Product product;

  const CreateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProductEvent extends ProductEvent {
  final Product product;

  const UpdateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProductEvent extends ProductEvent {
  final String productId;

  const DeleteProductEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}
