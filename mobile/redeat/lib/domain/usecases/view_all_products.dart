import '../repositories/product_repository.dart';
import '../entities/product.dart';
import 'usecase.dart';

class ViewAllProductsUseCase implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  ViewAllProductsUseCase(this.repository);

  @override
  Future<List<Product>> call(NoParams params) async {
    return await repository.getAllProducts();
  }
}