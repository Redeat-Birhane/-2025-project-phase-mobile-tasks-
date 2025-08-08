import 'package:flutter/material.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({Key? key, this.userName = ''}) : super(key: key);
  static Route route(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>? ?? {};
    final userName = args['userName'] as String? ?? '';
    return MaterialPageRoute(
      builder: (_) => HomePage(userName: userName),
    );
  }
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

    final displayName = (widget.userName.trim().isEmpty) ? '-' : widget.userName;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${widget.userName.isNotEmpty ? widget.userName : '-'}',
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
                  return ProductCard(
                    product: product,
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
          ).then((newProduct) {
            if (newProduct != null && newProduct is Map<String, dynamic>) {
              _addProduct(newProduct);
            }
          });
        },
        child: Icon(Icons.add, size: isMobile ? 24 : 28),
        backgroundColor: Colors.blue,
        tooltip: 'Add Product',
      ),
      floatingActionButtonLocation:
      isMobile ? FloatingActionButtonLocation.centerFloat : FloatingActionButtonLocation.endFloat,
    );
  }
}
