import '../../../domain/entities/product.dart';

/// Converts a Product entity to a JSON map
Map<String, dynamic> productToMap(Product product) {
  return {
    'id': product.id,
    'name': product.name,
    'description': product.description,
    'imageUrl': product.imageUrl,
    'price': product.price,
  };
}

/// Converts a JSON map to a Product entity
Product mapToProduct(Map<String, dynamic> map) {
  return Product(
    id: map['id'],
    name: map['name'],
    description: map['description'],
    imageUrl: map['imageUrl'],
    price: (map['price'] as num).toDouble(),
  );
}

/// Converts a List of JSON maps into a List of Product entities
List<Product> jsonListToProductList(List<dynamic> jsonList) {
  return jsonList.map((item) => mapToProduct(item)).toList();
}
