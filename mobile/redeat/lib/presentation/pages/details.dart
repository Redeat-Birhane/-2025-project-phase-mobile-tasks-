import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_product_usecase.dart';

class DetailsPage extends StatelessWidget {
  final Product product;
  final DeleteProductUsecase _deleteProductUsecase = DeleteProductUsecase(ViewAllProductsUsecase());

  DetailsPage({required this.product});

  void _delete(BuildContext context) async {
    await _deleteProductUsecase.call(product.id);
    Navigator.pop(context, null); // Return null after deletion
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product-${product.id}',
              child: Container(
                height: isMobile ? 200 : 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: isMobile ? 20 : 24),
            Text(product.name, style: TextStyle(fontSize: isMobile ? 22 : 26, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('\$${product.price}', style: TextStyle(fontSize: isMobile ? 20 : 24, color: Colors.blue)),
            SizedBox(height: 24),
            Text(product.description, style: TextStyle(fontSize: isMobile ? 16 : 18)),
            Spacer(),
            ElevatedButton(
              onPressed: () => _delete(context),
              child: Text('Delete Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
