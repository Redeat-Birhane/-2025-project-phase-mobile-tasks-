import '../entities/product.dart';
import '../repositories/product_repoisitory.dart';
import 'usecase.dart';
class GetProductUseCase implements UseCase<Product?, String> {
  final ProductRepository repository;

  GetProductUseCase(this.repository);

  @override
  Future<Product?> call(String id) {
    return repository.getProductById(id);
  }
}