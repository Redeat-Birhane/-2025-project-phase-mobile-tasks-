import '../repositories/product_repository.dart';
import '../entities/product.dart';
import 'usecase.dart';

class CreateProductUseCase implements UseCase<Product, Product> {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<Product> call(Product product) async {
    return await repository.createProduct(product);
  }
}