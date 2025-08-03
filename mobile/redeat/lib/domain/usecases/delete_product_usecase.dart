import '../repositories/product_repoisitory.dart';
import 'usecase.dart';

class DeleteProductUsecase extends UseCase<void, String> {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<void> call(String id) {
    return repository.deleteProduct(id);
  }
}
