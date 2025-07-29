import '../repositories/product_repository.dart';
import '../entities/product.dart';
import 'usecase.dart';

class ViewProductUseCase implements UseCase<Product, String> {
  final ProductRepository repository;

  ViewProductUseCase(this.repository);

  @override
  Future<Product> call(String productId) async {
    return await repository.getProduct(productId);
  }
}