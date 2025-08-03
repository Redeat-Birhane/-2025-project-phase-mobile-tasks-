import '../entities/product.dart';
import '../repositories/product_repoisitory.dart';
import 'usecase.dart';
class UpdateProductUseCase implements UseCase<void, Product> {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<void> call(Product product) {
    return repository.updateProduct(product);
  }
}