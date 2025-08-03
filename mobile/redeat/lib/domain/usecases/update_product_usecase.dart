import '../entities/product.dart';
import '../repositories/product_repoisitory.dart';
import 'usecase.dart';

class UpdateProductUsecase extends UseCase<void, Product> {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  @override
  Future<void> call(Product product) {
    return repository.updateProduct(product);
  }
}
