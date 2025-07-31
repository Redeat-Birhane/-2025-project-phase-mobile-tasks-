import '../entities/product.dart';
import 'view_all_products_usecase.dart';

class CreateProductUsecase {
  final ViewAllProductsUsecase _viewAllProductsUsecase;

  CreateProductUsecase(this._viewAllProductsUsecase);

  Future<void> call(Product product) async {
    final products = _viewAllProductsUsecase.products;
    products.add(product);
    await Future.delayed(Duration(milliseconds: 100));
  }
}
