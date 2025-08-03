import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetAllProductsUsecase {
  final ProductRepository repository;

  GetAllProductsUsecase(this.repository);

  Future<List<Product>> call() async {
    return await repository.getAllProducts();
  }
}
