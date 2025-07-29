import '../repositories/product_repository.dart';
import '../entities/product.dart';
import 'usecase.dart';

class UpdateProductUseCase implements UseCase<Product, Product> {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<Product> call(Product product) async {
    return await repository.updateProduct(product);
  }
}