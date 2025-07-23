import 'package:flutter/material.dart';
import 'details.dart';
import 'search.dart';
import 'add.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'name': 'Derby Leather Shoes',
      'price': 120.0,
      'category': "Men's shoe",
      'rating': 4.0,
      'image': 'assets/images/shoe.jpg',
      'description': 'Classic derby shoes made from premium leather...',
      'sizes': [39, 40, 41, 42, 43, 44],
    },
    {
      'id': '2',
      'name': 'Running Sneakers',
      'price': 85.0,
      'category': "Men's shoe",
      'rating': 4.5,
      'image': 'assets/images/shoe.jpg',
      'description': 'Lightweight running shoes with cushion technology...',
      'sizes': [40, 41, 42, 43],
    },
  ];

  void _addProduct(Map<String, dynamic> newProduct) {
    setState(() {
      products.add(newProduct);
    });
  }

  void _updateProduct(Map<String, dynamic> updatedProduct) {
    setState(() {
      final index = products.indexWhere((p) => p['id'] == updatedProduct['id']);
      if (index != -1) {
        products[index] = updatedProduct;
      }
    });
  }

  void _deleteProduct(String productId) {
    setState(() {
      products.removeWhere((p) => p['id'] == productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('July 14, 2023', style: TextStyle(fontSize: isMobile ? 12 : 14)),
                Text(
                  'Hello, Yohannes',
                  style: TextStyle(fontSize: isMobile ? 16 : 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.search, size: isMobile ? 24 : 28),
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Products',
              style: TextStyle(fontSize: isMobile ? 18 : 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: isMobile ? 12 : 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : 2,
                  childAspectRatio: isMobile ? 1.5 : 1.8,
                  crossAxisSpacing: isMobile ? 8 : 16,
                  mainAxisSpacing: isMobile ? 8 : 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/details',
                        arguments: {
                          'product': product,
                          'onDelete': () => _deleteProduct(product['id']),
                        },
                      ).then((updatedProduct) {
                        if (updatedProduct != null && updatedProduct is Map<String, dynamic>) {
                          _updateProduct(updatedProduct);
                        }
                      });
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Hero(
                              tag: 'product-${product['id']}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.asset(
                                  product['image'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(isMobile ? 8.0 : 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: TextStyle(
                                    fontSize: isMobile ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${product['price']}',
                                      style: TextStyle(
                                        fontSize: isMobile ? 14 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber, size: isMobile ? 14 : 16),
                                        Text(
                                          '(${product['rating']})',
                                          style: TextStyle(fontSize: isMobile ? 12 : 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  product['category'],
                                  style: TextStyle(
                                    fontSize: isMobile ? 12 : 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add',
            arguments: {
              'onSave': _addProduct,
            },
          );
        },
        child: Icon(Icons.add, size: isMobile ? 24 : 28),
        backgroundColor: Colors.blue,
        tooltip: 'Add Product',
      ),
      floatingActionButtonLocation: isMobile
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,
    );
  }
}
