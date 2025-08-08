import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class InsertProductUseCase {
  final ProductRepository repository;

  InsertProductUseCase(this.repository);

  Future<Either<Failure, void>> call(Product product) {
    return repository.createProduct(product);
  }
}
