import 'package:my_first_app/domain/usecases/view_all_products_usecase.dart';

class DeleteProductUsecase {
  final ViewAllProductsUsecase _viewAllProductsUsecase;

  DeleteProductUsecase(this._viewAllProductsUsecase);

  Future<void> call(String id) async {
    final products = _viewAllProductsUsecase.products;
    products.removeWhere((p) => p.id == id);
    await Future.delayed(Duration(milliseconds: 100));
  }
}
