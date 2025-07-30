import 'package:get_it/get_it.dart';
import 'package:my_first_app/data/repositories/product_repository_impl.dart';
import 'package:my_first_app/domain/repositories/product_repository.dart';
import 'package:my_first_app/domain/usecases/create_product.dart';
import 'package:my_first_app/domain/usecases/delete_product.dart';
import 'package:my_first_app/domain/usecases/update_product.dart';
import 'package:my_first_app/domain/usecases/view_all_products.dart';
import 'package:my_first_app/domain/usecases/view_product.dart';

final getIt = GetIt.instance;

void init() {

  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());


  getIt.registerLazySingleton(() => ViewAllProductsUseCase(getIt()));
  getIt.registerLazySingleton(() => ViewProductUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateProductUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateProductUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteProductUseCase(getIt()));
}