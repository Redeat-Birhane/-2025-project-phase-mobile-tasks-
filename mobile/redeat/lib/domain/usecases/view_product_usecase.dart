import '../entities/product.dart';
import 'view_all_products_usecase.dart';

class ViewProductUsecase {
  final ViewAllProductsUsecase _viewAllProductsUsecase;

  ViewProductUsecase(this._viewAllProductsUsecase);

  Future<Product?> call(String id) async {
    final products = await _viewAllProductsUsecase();
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {

      return null;
    }
  }
}
