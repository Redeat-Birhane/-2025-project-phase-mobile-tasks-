import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/features/product/data/models/product_model.dart';

void main() {
  group('ProductModel', () {
    final productModel = ProductModel(
      id: '1',
      name: 'Shoes',
      description: 'Running shoes',
      imageUrl: 'http://image.com/shoes.jpg',
      price: 59.99,
    );

    final json = {
      'id': '1',
      'name': 'Shoes',
      'description': 'Running shoes',
      'imageUrl': 'http://image.com/shoes.jpg',
      'price': 59.99,
    };

    test('fromJson creates correct ProductModel', () {
      final model = ProductModel.fromJson(json);
      expect(model.id, equals('1'));
      expect(model.name, equals('Shoes'));
      expect(model.description, equals('Running shoes'));
      expect(model.imageUrl, equals('http://image.com/shoes.jpg'));
      expect(model.price, equals(59.99));
    });

    test('toJson returns correct map', () {
      expect(productModel.toJson(), equals(json));
    });
  });
}
