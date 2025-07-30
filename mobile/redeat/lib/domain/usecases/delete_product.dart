import '../repositories/product_repository.dart';
import 'usecase.dart';

class DeleteProductUseCase implements UseCase<void, String> {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<void> call(String productId) async {
    await repository.deleteProduct(productId);
  }
}