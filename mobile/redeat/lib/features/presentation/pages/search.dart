import 'package:flutter/material.dart';
import '../widgets/product_card.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = '';
  double _minPrice = 0;
  double _maxPrice = 200;

  // Sample product list (replace or integrate with your actual products)
  final List<Map<String, dynamic>> _allProducts = [
    {
      'id': '1',
      'name': 'Derby Leather Shoes',
      'category': 'Leather',
      'price': 120.0,
      'description': "Classic derby shoes made from premium leather",
      'rating': 4.0,
      'sizes': [39, 40, 41, 42, 43, 44],
      'image': 'assets/images/shoe.jpg',
    },
    {
      'id': '2',
      'name': 'Classic Sneakers',
      'category': 'Sneakers',
      'price': 80.0,
      'description': "Lightweight casual sneakers",
      'rating': 4.5,
      'sizes': [40, 41, 42, 43],
      'image': 'assets/images/shoe.jpg',
    },
    {
      'id': '3',
      'name': 'Formal Black Shoes',
      'category': 'Formal',
      'price': 150.0,
      'description': "Perfect for office",
      'rating': 4.2,
      'sizes': [40, 41, 42],
      'image': 'assets/images/shoe.jpg',
    },
    {
      'id': '4',
      'name': 'Casual Loafers',
      'category': 'Casual',
      'price': 70.0,
      'description': "Comfortable everyday shoes",
      'rating': 4.1,
      'sizes': [39, 40, 41],
      'image': 'assets/images/shoe.jpg',
    },
  ];

  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(_allProducts);
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final name = product['name'].toString().toLowerCase();
        final category = product['category'].toString().toLowerCase();
        final price = product['price'] as num;

        final matchesQuery = query.isEmpty || name.contains(query);
        final matchesCategory = _selectedCategory.isEmpty || category == _selectedCategory.toLowerCase();
        final matchesPrice = price >= _minPrice && price <= _maxPrice;

        return matchesQuery && matchesCategory && matchesPrice;
      }).toList();
    });
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _selectedCategory = '';
      _minPrice = 0;
      _maxPrice = 200;
      _filteredProducts = List.from(_allProducts);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Products'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            tooltip: 'Clear Filters',
            onPressed: _clearFilters,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Product',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _applyFilters();
                  },
                ),
              ),
              onSubmitted: (_) => _applyFilters(),
            ),
            SizedBox(height: isMobile ? 16 : 24),


            Text(
              'Category',
              style: TextStyle(fontSize: isMobile ? 16 : 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Leather', 'Sneakers', 'Formal', 'Casual'].map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? category : '';
                    });
                    _applyFilters();
                  },
                );
              }).toList(),
            ),
            SizedBox(height: isMobile ? 16 : 24),

            // Price Range filter
            Text(
              'Price Range',
              style: TextStyle(fontSize: isMobile ? 16 : 18, fontWeight: FontWeight.bold),
            ),
            RangeSlider(
              values: RangeValues(_minPrice, _maxPrice),
              min: 0,
              max: 200,
              divisions: 20,
              labels: RangeLabels('\$${_minPrice.toInt()}', '\$${_maxPrice.toInt()}'),
              onChanged: (values) {
                setState(() {
                  _minPrice = values.start;
                  _maxPrice = values.end;
                });
                _applyFilters();
              },
            ),
            SizedBox(height: isMobile ? 16 : 24),


            Text(
              'Results (${_filteredProducts.length})',
              style: TextStyle(fontSize: isMobile ? 18 : 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: isMobile ? 12 : 16),


            Expanded(
              child: _filteredProducts.isEmpty
                  ? Center(child: Text('No products found'))
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : 2,
                  childAspectRatio: isMobile ? 1.5 : 1.8,
                  crossAxisSpacing: isMobile ? 8 : 16,
                  mainAxisSpacing: isMobile ? 8 : 16,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/details',
                        arguments: {
                          'product': product,
                          'onDelete': () {
                            setState(() {
                              _allProducts.removeWhere((p) => p['id'] == product['id']);
                              _applyFilters();
                            });
                            Navigator.pop(context);
                          },
                        },
                      ).then((updatedProduct) {
                        if (updatedProduct != null && updatedProduct is Map<String, dynamic>) {
                          final idx = _allProducts.indexWhere((p) => p['id'] == updatedProduct['id']);
                          if (idx != -1) {
                            setState(() {
                              _allProducts[idx] = updatedProduct;
                              _applyFilters();
                            });
                          }
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
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
