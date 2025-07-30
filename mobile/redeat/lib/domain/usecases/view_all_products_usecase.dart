import '../entities/product.dart';

class ViewAllProductsUsecase {
  static final List<Product> _products = [
    Product(
      id: '1',
      name: 'Derby Leather Shoes',
      description: 'Classic derby shoes made from premium leather.',
      imageUrl: 'assets/images/shoe.jpg',
      price: 120.0,
    ),
    Product(
      id: '2',
      name: 'Running Sneakers',
      description: 'Lightweight running shoes with cushion technology.',
      imageUrl: 'assets/images/shoe.jpg',
      price: 85.0,
    ),
  ];

  Future<List<Product>> call() async {

    await Future.delayed(Duration(milliseconds: 300));
    return List<Product>.from(_products);
  }


  List<Product> get products => _products;
}
