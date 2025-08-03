<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'details.dart';

class SearchPage extends StatefulWidget {
=======
import 'package:flutter/material.dart' hide SearchController;
import '../../core/constants/app_strings.dart';
import '../../core/utils/helpers.dart';
import '../../domain/entities/product.dart';
import '../widgets/category_filter.dart';
import '../widgets/price_slider.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';
import '../controllers/search_controller.dart' as my_search;

class SearchPage extends StatefulWidget {
  final List<Product> allProducts;

  const SearchPage({required this.allProducts, Key? key}) : super(key: key);

>>>>>>> 2c7e21de02ed67c6fb7eff93b3b3ab7a9a28850c
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = '';
  double _minPrice = 0;
  double _maxPrice = 200;
<<<<<<< HEAD

  // Sample product list
  final List<Map<String, dynamic>> _allProducts = [
    {
      'name': 'Derby Leather Shoes',
      'category': 'Leather',
      'price': 120,
      'description': "Men's shoe",
      'rating': 4.0,
    },
    {
      'name': 'Classic Sneakers',
      'category': 'Sneakers',
      'price': 80,
      'description': "Casual sneaker",
      'rating': 4.5,
    },
    {
      'name': 'Formal Black Shoes',
      'category': 'Formal',
      'price': 150,
      'description': "Perfect for office",
      'rating': 4.2,
    },
    {
      'name': 'Casual Loafers',
      'category': 'Casual',
      'price': 70,
      'description': "Comfortable everyday shoes",
      'rating': 4.1,
    },
  ];

  List<Map<String, dynamic>> _filteredProducts = [];
=======
  List<Product> _filteredProducts = [];

  late my_search.SearchController _searchControllerLogic;
>>>>>>> 2c7e21de02ed67c6fb7eff93b3b3ab7a9a28850c

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD

=======
    _searchControllerLogic = my_search.SearchController(allProducts: widget.allProducts);
>>>>>>> 2c7e21de02ed67c6fb7eff93b3b3ab7a9a28850c
    _filteredProducts = [];
  }

  void _applyFilters() {
<<<<<<< HEAD
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final name = product['name'].toString().toLowerCase();
        final category = product['category'].toString();
        final price = product['price'] as num;

        final matchesQuery = query.isEmpty || name.contains(query);
        final matchesCategory = _selectedCategory.isEmpty || category.toLowerCase() == _selectedCategory.toLowerCase();
        final matchesPrice = price >= _minPrice && price <= _maxPrice;

        return matchesQuery && matchesCategory && matchesPrice;
      }).toList();
=======
    final results = _searchControllerLogic.filter(
      query: _searchController.text,
      category: _selectedCategory,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
    );

    setState(() {
      _filteredProducts = results;
>>>>>>> 2c7e21de02ed67c6fb7eff93b3b3ab7a9a28850c
    });
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search TextField
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Product',
=======
    final mobile = isMobile(context);
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.searchLabel)),
      body: Padding(
        padding: EdgeInsets.all(mobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: AppStrings.searchLabel,
>>>>>>> 2c7e21de02ed67c6fb7eff93b3b3ab7a9a28850c
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
<<<<<<< HEAD
                    // Optionally clear filtered products or keep previous results
                    // setState(() {
                    //   _filteredProducts = [];
                    // });
=======
                    setState(() {
                      _filteredProducts = [];
                    });
>>>>>>> 2c7e21de02ed67c6fb7eff93b3b3ab7a9a28850c
                  },
                ),
              ),
            ),
<<<<<<< HEAD
            SizedBox(height: isMobile ? 16 : 24),

            // Category filter using ChoiceChip
            Text(
              'Category',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
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
                  },
                );
              }).toList(),
            ),
            SizedBox(height: isMobile ? 16 : 24),

            // Price range filter
            Text(
              'Price',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            RangeSlider(
              values: RangeValues(_minPrice, _maxPrice),
              min: 0,
              max: 200,
              divisions: 10,
              labels: RangeLabels('\$${_minPrice.toInt()}', '\$${_maxPrice.toInt()}'),
              onChanged: (values) {
                setState(() {
                  _minPrice = values.start;
                  _maxPrice = values.end;
                });
              },
            ),
            SizedBox(height: isMobile ? 16 : 24),

            // Apply button triggers filtering
=======
            SizedBox(height: mobile ? 16 : 24),
            Text(AppStrings.categoryLabel, style: TextStyle(fontSize: mobile ? 16 : 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            CategoryFilter(
              categories: ['Leather', 'Sneakers', 'Formal', 'Casual'],
              selectedCategory: _selectedCategory,
              onCategorySelected: (cat) {
                setState(() {
                  _selectedCategory = cat;
                });
              },
            ),
            SizedBox(height: mobile ? 16 : 24),
            Text(AppStrings.priceLabel, style: TextStyle(fontSize: mobile ? 16 : 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            PriceSlider(
              minPrice: _minPrice,
              maxPrice: _maxPrice,
              onChanged: (range) {
                setState(() {
                  _minPrice = range.start;
                  _maxPrice = range.end;
                });
              },
            ),
            SizedBox(height: mobile ? 16 : 24),
>>>>>>> 2c7e21de02ed67c6fb7eff93b3b3ab7a9a28850c
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
<<<<<<< HEAD
                child: Text('APPLY'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: isMobile ? 16 : 24),

            // Results header
            Text(
              'Results (${_filteredProducts.length})',
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),

            // Results list
            Expanded(
              child: _filteredProducts.isEmpty
                  ? Center(child: Text('No products found'))
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
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('\$${product['price']}'),
                                Text(product['description']),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
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
=======
                child: Text(AppStrings.applyButton),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: mobile ? 14 : 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            SizedBox(height: mobile ? 16 : 24),
            Text('${AppStrings.resultsLabel} (${_filteredProducts.length})', style: TextStyle(fontSize: mobile ? 18 : 20, fontWeight: FontWeight.bold)),
            SizedBox(height: mobile ? 12 : 16),
            Expanded(
              child: _filteredProducts.isEmpty
                  ? EmptyState(message: 'No products found')
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: mobile ? 1 : 2,
                  childAspectRatio: mobile ? 1.5 : 1.8,
                  crossAxisSpacing: mobile ? 8 : 16,
                  mainAxisSpacing: mobile ? 8 : 16,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (_, index) => ProductCard(product: _filteredProducts[index]),
>>>>>>> 2c7e21de02ed67c6fb7eff93b3b3ab7a9a28850c
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
<<<<<<< HEAD
}
=======
}
>>>>>>> 2c7e21de02ed67c6fb7eff93b3b3ab7a9a28850c
