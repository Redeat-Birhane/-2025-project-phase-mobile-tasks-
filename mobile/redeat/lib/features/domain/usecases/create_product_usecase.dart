import '../entities/product.dart';
import '../repositories/product_repoisitory.dart';
import 'usecase.dart';

class CreateProductUsecase extends UseCase<void, Product> {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  @override
  Future<void> call(Product product) {
    return repository.createProduct(product);
  }
}
