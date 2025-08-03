import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/features/product/data/models/product_model.dart';


void main() {
  const productJson = {
    'id': '1',
    'name': 'Test Product',
    'description': 'A test product',
    'imageUrl': 'http://example.com/image.png',
    'price': 99.99,
  };

  const productModel = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'A test product',
    imageUrl: 'http://example.com/image.png',
    price: 99.99,
  );

  test('fromJson returns correct ProductModel', () {
    final result = ProductModel.fromJson(productJson);
    expect(result, isA<ProductModel>());
    expect(result.id, '1');
    expect(result.name, 'Test Product');
    expect(result.description, 'A test product');
    expect(result.imageUrl, 'http://example.com/image.png');
    expect(result.price, 99.99);
  });

  test('toJson returns correct map', () {
    final result = productModel.toJson();
    expect(result, productJson);
  });
}
