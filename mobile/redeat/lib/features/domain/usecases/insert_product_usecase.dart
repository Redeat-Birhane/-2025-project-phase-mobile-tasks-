import '../entities/product.dart';
import '../repositories/product_repoisitory.dart';
import 'usecase.dart';
class InsertProductUseCase implements UseCase<void, Product> {
  final ProductRepository repository;

  InsertProductUseCase(this.repository);

  @override
  Future<void> call(Product product) {
    return repository.createProduct(product);
  }
}