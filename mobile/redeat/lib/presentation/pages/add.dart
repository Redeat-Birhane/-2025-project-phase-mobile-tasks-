import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import 'package:my_first_app/domain/usecases/create_product_usecase.dart';
import 'package:my_first_app/domain/usecases/update_product_usecase.dart';
import 'package:uuid/uuid.dart';

import '../../domain/usecases/view_all_products_usecase.dart';

class AddUpdatePage extends StatefulWidget {
  final Product? product;

  AddUpdatePage({this.product});

  @override
  _AddUpdatePageState createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = Uuid();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;

  late CreateProductUsecase _createProductUsecase;
  late UpdateProductUsecase _updateProductUsecase;

  @override
  void initState() {
    super.initState();

    _createProductUsecase = CreateProductUsecase(ViewAllProductsUsecase());
    _updateProductUsecase = UpdateProductUsecase(ViewAllProductsUsecase());

    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _imageUrlController = TextEditingController(text: widget.product?.imageUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final description = _descriptionController.text.trim();
    final imageUrl = _imageUrlController.text.trim();

    if (widget.product == null) {
      final newProduct = Product(
        id: _uuid.v4(),
        name: name,
        description: description,
        imageUrl: imageUrl.isEmpty ? 'assets/images/shoe.jpg' : imageUrl,
        price: price,
      );
      await _createProductUsecase.call(newProduct);
      Navigator.pop(context, newProduct);
    } else {
      final updatedProduct = widget.product!.copyWith(
        name: name,
        description: description,
        imageUrl: imageUrl.isEmpty ? 'assets/images/shoe.jpg' : imageUrl,
        price: price,
      );
      await _updateProductUsecase.call(updatedProduct);
      Navigator.pop(context, updatedProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(title: Text(widget.product == null ? 'Add Product' : 'Update Product')),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter a name' : null,
              ),
              SizedBox(height: isMobile ? 12 : 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter a price' : null,
              ),
              SizedBox(height: isMobile ? 12 : 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: isMobile ? 12 : 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              SizedBox(height: isMobile ? 12 : 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.product == null ? 'Add Product' : 'Update Product'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
