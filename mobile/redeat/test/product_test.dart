import 'package:my_first_app/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/domain/entities/product.dart';

void main() {
  group('Product Entity', () {
    final testProduct = Product(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      imageUrl: 'test.jpg',
      price: 99.99,
      category: 'Test Category',
      rating: 4.5,
      sizes: const [39, 40, 41],
    );

    test('should create a valid product', () {
      expect(testProduct.id, '1');
      expect(testProduct.name, 'Test Product');
      expect(testProduct.price, 99.99);
    });

    test('should support value equality', () {
      final product1 = Product(
        id: '1',
        name: 'Test',
        description: 'Desc',
        imageUrl: 'img.jpg',
        price: 10,
        category: 'Cat',
      );
      final product2 = Product(
        id: '1',
        name: 'Test',
        description: 'Desc',
        imageUrl: 'img.jpg',
        price: 10,
        category: 'Cat',
      );
      expect(product1, product2);
    });

    test('copyWith should create new instance with updated values', () {
      final updated = testProduct.copyWith(name: 'Updated Name', price: 199.99);
      expect(updated.name, 'Updated Name');
      expect(updated.price, 199.99);
      expect(updated.category, testProduct.category); // unchanged
    });
  });
}