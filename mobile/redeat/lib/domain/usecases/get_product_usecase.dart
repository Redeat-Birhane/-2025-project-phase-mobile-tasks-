import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductUsecase {
  final ProductRepository repository;

  GetProductUsecase(this.repository);

  Future<Product?> call(String id) async {
    return await repository.getProductById(id);
  }
}
