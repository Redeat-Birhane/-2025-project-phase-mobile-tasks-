class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
  final double rating;
  final List<int> sizes;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    this.rating = 0.0,
    this.sizes = const [],
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    String? category,
    double? rating,
    List<int>? sizes,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      sizes: sizes ?? this.sizes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.price == price &&
        other.category == category &&
        other.rating == rating &&
        other.sizes == sizes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    description.hashCode ^
    imageUrl.hashCode ^
    price.hashCode ^
    category.hashCode ^
    rating.hashCode ^
    sizes.hashCode;
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, imageUrl: $imageUrl, price: $price, category: $category, rating: $rating, sizes: $sizes)';
  }
}