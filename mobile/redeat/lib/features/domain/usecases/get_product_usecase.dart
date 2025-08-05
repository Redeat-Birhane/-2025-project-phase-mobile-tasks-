import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class GetProductUseCase implements UseCase<Either<Failure, Product>, String> {
  final ProductRepository repository;

  GetProductUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(String id) {
    return repository.getProductById(id);
  }
}
