import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/data/models/product_model.dart';

void main() {
  group('ProductModel', () {
    final productJson = {
      'id': '123',
      'name': 'Test Product',
      'description': 'Test description',
      'price': 99.99,
      'imageUrl': 'http://example.com/image.jpg',
    };

    final productModel = ProductModel(
      id: '123',
      name: 'Test Product',
      description: 'Test description',
      price: 99.99,
      imageUrl: 'http://example.com/image.jpg',
    );

    test('fromJson should return a valid ProductModel', () {
      final result = ProductModel.fromJson(productJson);
      expect(result.id, productModel.id);
      expect(result.name, productModel.name);
      expect(result.description, productModel.description);
      expect(result.price, productModel.price);
      expect(result.imageUrl, productModel.imageUrl);
    });

    test('toJson should return a valid JSON map', () {
      final result = productModel.toJson();
      expect(result, productJson);
    });
  });
}
