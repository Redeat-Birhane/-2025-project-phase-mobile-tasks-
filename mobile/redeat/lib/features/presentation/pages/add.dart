import 'dart:io';

import 'package:flutter/material.dart';

class AddUpdatePage extends StatefulWidget {
  final Map<String, dynamic>? product;
  final String userEmail;

  const AddUpdatePage({Key? key, this.product, required this.userEmail})
      : super(key: key);

  @override
  _AddUpdatePageState createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late String _category;
  late String _description;
  late List<int> _sizes;
  String _imagePath = 'assets/images/shoe.jpg';

  final List<String> _categories = ['Leather', 'Sneakers', 'Formal', 'Casual'];
  final List<int> _availableSizes = [39, 40, 41, 42, 43, 44];

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    if (product != null) {
      _name = product['name'] ?? '';
      _price = (product['price'] ?? 0).toDouble();
      _category = product['category'] ?? _categories.first;
      _description = product['description'] ?? '';
      _sizes = List<int>.from(product['sizes'] ?? _availableSizes);
      _imagePath = product['image'] ?? _imagePath;
    } else {
      _name = '';
      _price = 0;
      _category = _categories.first;
      _description = '';
      _sizes = [];
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final product = widget.product;
      final updatedProduct = <String, dynamic>{
        'id': product != null ? product['id'] : DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _name,
        'price': _price,
        'category': _category,
        'description': _description,
        'sizes': _sizes,
        'image': _imagePath,
        'owner': widget.userEmail,
        'rating': product != null ? product['rating'] ?? 0.0 : 0.0,
      };

      Navigator.pop(context, updatedProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Update Product'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (val) => val == null || val.isEmpty ? 'Enter product name' : null,
                onSaved: (val) => _name = val ?? '',
              ),
              SizedBox(height: isMobile ? 12 : 16),


              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter price';
                  if (double.tryParse(val) == null) return 'Enter a valid number';
                  return null;
                },
                onSaved: (val) => _price = double.parse(val ?? '0'),
              ),
              SizedBox(height: isMobile ? 12 : 16),


              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              SizedBox(height: isMobile ? 12 : 16),

              // Sizes (multi-select)
              Text(
                'Sizes',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 16 : 18),
              ),
              Wrap(
                spacing: 8,
                children: _availableSizes.map((size) {
                  final selected = _sizes.contains(size);
                  return FilterChip(
                    label: Text(size.toString()),
                    selected: selected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _sizes.add(size);
                        } else {
                          _sizes.remove(size);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: isMobile ? 12 : 16),


              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (val) => _description = val ?? '',
              ),
              SizedBox(height: isMobile ? 24 : 32),

              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.product == null ? 'Add Product' : 'Update Product'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
