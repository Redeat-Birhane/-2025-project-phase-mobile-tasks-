import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getAllProducts();

  Future<Either<Failure, Product>> getProductById(String id);

  Future<Either<Failure, void>> createProduct(Product product);  // add image param if needed

  Future<Either<Failure, void>> updateProduct(Product product);

  Future<Either<Failure, void>> deleteProduct(String id);
}
