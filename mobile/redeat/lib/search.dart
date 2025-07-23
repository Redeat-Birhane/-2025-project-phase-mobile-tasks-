import 'package:flutter/material.dart';
import 'details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = '';
  double _minPrice = 0;
  double _maxPrice = 200;

  final List<Map<String, dynamic>> _allProducts = [
    {
      'name': 'Derby Leather Shoes',
      'category': 'Leather',
      'price': 120,
      'description': 'Men\'s shoe',
      'rating': 4.0,
    },
    {
      'name': 'Classic Sneakers',
      'category': 'Sneakers',
      'price': 80,
      'description': 'Casual sneaker',
      'rating': 4.5,
    },
    {
      'name': 'Formal Black Shoes',
      'category': 'Formal',
      'price': 150,
      'description': 'Perfect for office',
      'rating': 4.2,
    },
    {
      'name': 'Casual Loafers',
      'category': 'Casual',
      'price': 70,
      'description': 'Comfortable everyday shoes',
      'rating': 4.1,
    },
  ];

  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = [];
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final name = product['name'].toString().toLowerCase();
        final category = product['category'].toString();
        final price = product['price'] as num;

        final matchesQuery = query.isEmpty || name.contains(query);
        final matchesCategory = _selectedCategory.isEmpty ||
            category.toLowerCase() == _selectedCategory.toLowerCase();
        final matchesPrice = price >= _minPrice && price <= _maxPrice;

        return matchesQuery && matchesCategory && matchesPrice;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
        centerTitle: true,
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
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                ),
              ),
            ),
            SizedBox(height: isMobile ? 16 : 24),
            Text(
              'Category',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
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
                  },
                );
              }).toList(),
            ),
            SizedBox(height: isMobile ? 16 : 24),
            Text(
              'Price',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            RangeSlider(
              values: RangeValues(_minPrice, _maxPrice),
              min: 0,
              max: 200,
              divisions: 10,
              labels: RangeLabels(
                '\$${_minPrice.toInt()}',
                '\$${_maxPrice.toInt()}',
              ),
              onChanged: (values) {
                setState(() {
                  _minPrice = values.start;
                  _maxPrice = values.end;
                });
              },
            ),
            SizedBox(height: isMobile ? 16 : 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('APPLY'),
              ),
            ),
            SizedBox(height: isMobile ? 16 : 24),
            Text(
              'Results (${_filteredProducts.length})',
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Expanded(
              child: _filteredProducts.isEmpty
                  ? const Center(child: Text('No products found'))
                  : ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(
                            product: product,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: TextStyle(
                                fontSize: isMobile ? 18 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('\$${product['price']}'),
                                Text(product['description']),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    Text('(${product['rating']})'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
