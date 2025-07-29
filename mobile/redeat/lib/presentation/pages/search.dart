import 'package:flutter/material.dart';
import 'package:my_first_app/domain/entities/product.dart';
import 'package:my_first_app/domain/usecases/search_products.dart';
import 'package:my_first_app/presentation/pages/details.dart';

import '../../injection_container.dart';

class SearchPage extends StatefulWidget {
  final SearchProductsUseCase searchProductsUseCase;

  const SearchPage({
    super.key,
    required this.searchProductsUseCase,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = '';
  double _minPrice = 0;
  double _maxPrice = 200;
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  bool _filtersApplied = false;

  final List<String> _categories = [
    'Leather',
    'Sneakers',
    'Formal',
    'Casual',
    'Sports',
    'Sandals'
  ];

  @override
  void initState() {
    super.initState();
    _filteredProducts = [];
  }

  Future<void> _searchProducts() async {
    setState(() => _isLoading = true);
    try {
      final results = await widget.searchProductsUseCase(SearchParams(
        query: _searchController.text,
        category: _selectedCategory,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
      ));
      setState(() {
        _filteredProducts = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: $e')),
      );
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = '';
      _minPrice = 0;
      _maxPrice = 200;
      _filtersApplied = false;
      _filteredProducts = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
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
                  onPressed: _clearFilters,
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? category : '';
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: isMobile ? 16 : 24),

            Text(
              'Price Range: \$${_minPrice.toInt()} - \$${_maxPrice.toInt()}',
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

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _searchProducts,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('APPLY FILTERS'),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _clearFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('CLEAR', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 16 : 24),

            if (_filtersApplied) ...[
              Text(
                'Results (${_filteredProducts.length})',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isMobile ? 12 : 16),
            ],

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredProducts.isEmpty && _filtersApplied
                  ? const Center(child: Text('No products found matching your criteria'))
                  : _filteredProducts.isEmpty
                  ? const Center(child: Text('Apply filters to see results'))
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
                              product.name,
                              style: TextStyle(
                                fontSize: isMobile ? 18 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text('\$${product.price}'),
                                Text(product.category),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    Text('(${product.rating})'),
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