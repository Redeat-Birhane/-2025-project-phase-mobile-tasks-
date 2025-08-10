import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class GetAllProductsUseCase implements UseCase<Either<Failure, List<Product>>, void> {
  final ProductRepository repository;

  GetAllProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call([void _]) {
    return repository.getAllProducts();
  }
}
