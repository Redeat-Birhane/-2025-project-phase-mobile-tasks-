import '../repositories/product_repoisitory.dart';
import 'usecase.dart';
class DeleteProductUseCase implements UseCase<void, String> {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<void> call(String id) {
    return repository.deleteProduct(id);
  }
}