import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Derby Leather Shoes',
      description: 'Classic derby shoes made from premium leather...',
      imageUrl: 'assets/images/shoe.jpg',
      price: 120.0,
      category: "Men's shoe",
      rating: 4.0,
      sizes: [39, 40, 41, 42, 43, 44],
    ),
    Product(
      id: '2',
      name: 'Running Sneakers',
      description: 'Lightweight running shoes with cushion technology...',
      imageUrl: 'assets/images/shoe.jpg',
      price: 85.0,
      category: "Men's shoe",
      rating: 4.5,
      sizes: [40, 41, 42, 43],
    ),
  ];

  @override
  Future<List<Product>> getAllProducts() async {
    return _products;
  }

  @override
  Future<Product> getProduct(String id) async {
    return _products.firstWhere((product) => product.id == id);
  }

  @override
  Future<Product> createProduct(Product product) async {
    _products.add(product);
    return product;
  }

  @override
  Future<Product> updateProduct(Product updatedProduct) async {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
    }
    return updatedProduct;
  }

  @override
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((product) => product.id == id);
  }
}