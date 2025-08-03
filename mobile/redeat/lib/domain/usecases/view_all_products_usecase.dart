import '../entities/product.dart';
import '../repositories/product_repoisitory.dart';
import 'usecase.dart';

class ViewAllProductsUsecase extends UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  ViewAllProductsUsecase(this.repository);

  @override
  Future<List<Product>> call(NoParams params) {
    return repository.getAllProducts();
  }
}
