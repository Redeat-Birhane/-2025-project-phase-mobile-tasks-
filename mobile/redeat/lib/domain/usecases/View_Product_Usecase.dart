import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class ViewProductUsecase extends UseCase<Product, String> {
  final ProductRepository repository;

  ViewProductUsecase(this.repository);

  @override
  Future<Product> call(String id) {
    return repository.getProductById(id);
  }
}
