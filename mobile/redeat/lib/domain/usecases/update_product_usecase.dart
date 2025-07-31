import '../entities/product.dart';
import 'package:my_first_app/domain/usecases/view_all_products_usecase.dart';

class UpdateProductUsecase {
  final ViewAllProductsUsecase _viewAllProductsUsecase;

  UpdateProductUsecase(this._viewAllProductsUsecase);

  Future<void> call(Product updatedProduct) async {
    final products = _viewAllProductsUsecase.products;
    final index = products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      products[index] = updatedProduct;
    }
    await Future.delayed(Duration(milliseconds: 100));
  }
}
