import 'package:flutter/material.dart';
import 'dart:io';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function()? onDelete;

  const DetailsPage({
    Key? key,
    required this.product,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final category = product['category'] ?? "Product";
    final name = product['name'] ?? "Unnamed Product";
    final price = '\$${product['price'] ?? 0}';
    final rating = product['rating']?.toString() ?? "0.0";
    final sizes = product['sizes'] is List ? product['sizes'] as List<int> : [39, 40, 41, 42];
    final description = product['description'] ?? "No description available";
    final image = product['image'] ?? 'assets/images/shoe.jpg';

    ImageProvider<Object> imageProvider;
    if (image.toString().startsWith('assets/')) {
      imageProvider = AssetImage(image);
    } else {
      imageProvider = FileImage(File(image));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'product-${product['id'] ?? 'default'}',
                child: Container(
                  height: isMobile ? 200 : 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 20 : 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        '($rating)',
                        style: TextStyle(fontSize: isMobile ? 16 : 18),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 12 : 16),
              Text(
                name,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                price,
                style: TextStyle(
                  fontSize: isMobile ? 24 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: isMobile ? 16 : 24),
              Text(
                'Size:',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: sizes
                    .map<Widget>((size) => Chip(
                  label: Text(size.toString()),
                  backgroundColor: Colors.grey[200],
                  shape: StadiumBorder(
                    side: BorderSide(color: Colors.grey),
                  ),
                ))
                    .toList(),
              ),
              SizedBox(height: isMobile ? 24 : 32),
              Text(
                description,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: isMobile ? 24 : 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showDeleteConfirmation(context),
                      child: Text(
                        'DELETE',
                        style: TextStyle(fontSize: isMobile ? 14 : 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isMobile ? 16 : 24),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/add',
                          arguments: {'product': product},
                        ).then((updatedProduct) {
                          if (updatedProduct != null && updatedProduct is Map<String, dynamic>) {
                            Navigator.pop(context, updatedProduct);
                          }
                        });
                      },
                      child: Text('UPDATE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                if (onDelete != null) onDelete!();
                Navigator.of(context).pop(); // Pop DetailsPage after delete
              },
              child: const Text('DELETE', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
