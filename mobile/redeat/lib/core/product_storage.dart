class ProductStorage {
  static final ProductStorage _instance = ProductStorage._internal();

  factory ProductStorage() => _instance;

  ProductStorage._internal();

  final Map<String, List<Map<String, dynamic>>> _productsByUser = {
    'demo@example.com': [
      {
        'id': '1',
        'name': 'Derby Leather Shoes',
        'price': 120.0,
        'category': "Men's shoe",
        'rating': 4.0,
        'image': 'assets/images/shoe.jpg',
        'description': 'Classic derby shoes made from premium leather...',
        'sizes': [39, 40, 41, 42, 43, 44],
        'owner': 'demo@example.com',
      },
    ],

  };

  List<Map<String, dynamic>> getProductsForUser(String email) {
    return _productsByUser[email] ?? [];
  }

  void setProductsForUser(String email, List<Map<String, dynamic>> products) {
    _productsByUser[email] = products;
  }
}
