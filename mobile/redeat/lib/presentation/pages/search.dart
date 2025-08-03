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

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = '';
  double _minPrice = 0;
  double _maxPrice = 200;
  List<Product> _filteredProducts = [];

  late my_search.SearchController _searchControllerLogic;

  @override
  void initState() {
    super.initState();
    _searchControllerLogic = my_search.SearchController(allProducts: widget.allProducts);
    _filteredProducts = [];
  }

  void _applyFilters() {
    final results = _searchControllerLogic.filter(
      query: _searchController.text,
      category: _selectedCategory,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
    );

    setState(() {
      _filteredProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _filteredProducts = [];
                    });
                  },
                ),
              ),
            ),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
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
