import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/view_all_products_usecase.dart';
import '../../domain/usecases/create_product_usecase.dart';
import 'details.dart';
import 'add.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ViewAllProductsUsecase _viewAllProductsUsecase;
  late final CreateProductUsecase _createProductUsecase;

  List<Product> _products = [];

  @override
  void initState() {
    super.initState();

    _viewAllProductsUsecase = ViewAllProductsUsecase();
    _createProductUsecase = CreateProductUsecase(_viewAllProductsUsecase);

    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _viewAllProductsUsecase.call();
    setState(() {
      _products = products;
    });
  }

  void _navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddUpdatePage(),
      ),
    );

    if (result is Product) {
      await _createProductUsecase.call(result);
      await _loadProducts(); // Refresh the list after adding
    }
  }

  void _navigateToDetails(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(product: product),
      ),
    );

    if (result != null && result is Product) {
      await _loadProducts(); // Refresh after update or delete
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Products'),
      ),
      body: _products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(isMobile ? 8 : 16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 1 : 2,
            childAspectRatio: isMobile ? 1.5 : 1.8,
            crossAxisSpacing: isMobile ? 8 : 16,
            mainAxisSpacing: isMobile ? 8 : 16,
          ),
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return GestureDetector(
              onTap: () => _navigateToDetails(product),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Hero(
                        tag: 'product-${product.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.asset(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(isMobile ? 8 : 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: isMobile ? 16 : 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text('\$${product.price}',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        child: Icon(Icons.add),
      ),
    );
  }
}
