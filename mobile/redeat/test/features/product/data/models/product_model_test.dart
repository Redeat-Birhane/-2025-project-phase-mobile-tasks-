import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/features/product/data/models/product_model.dart';

void main() {
  group('ProductModel', () {
    final tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      description: 'This is a test product',
      imageUrl: 'http://example.com/image.jpg',
      price: 99.99,
    );

    final tProductJson = {
      'id': '1',
      'name': 'Test Product',
      'description': 'This is a test product',
      'imageUrl': 'http://example.com/image.jpg',
      'price': 99.99,
    };

    test('fromJson should return a valid model', () {
      final result = ProductModel.fromJson(tProductJson);
      expect(result, equals(tProductModel));
    });

    test('toJson should return a valid JSON map', () {
      final result = tProductModel.toJson();
      expect(result, equals(tProductJson));
    });
  });
}
