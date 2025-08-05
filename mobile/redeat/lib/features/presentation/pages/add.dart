import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddUpdatePage extends StatefulWidget {
  final Map<String, dynamic>? product;

  const AddUpdatePage({Key? key, this.product}) : super(key: key);

  @override
  _AddUpdatePageState createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;

  double _rating = 0;
  List<int> _sizes = [];

  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?['name'] ?? '');
    _priceController = TextEditingController(text: product?['price']?.toString() ?? '');
    _categoryController = TextEditingController(text: product?['category'] ?? '');
    _descriptionController = TextEditingController(text: product?['description'] ?? '');
    _rating = product?['rating'] ?? 0;
    _sizes = List<int>.from(product?['sizes'] ?? []);
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = picked;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final productData = {
        'id': widget.product?['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _nameController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'category': _categoryController.text.trim(),
        'rating': _rating,
        'description': _descriptionController.text.trim(),
        'sizes': _sizes,
        'image': _pickedImage?.path ?? widget.product?['image'] ?? 'assets/images/shoe.jpg',
      };

      Navigator.pop(context, productData); // Return updated/new product
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Update Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: isMobile ? 150 : 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300],
                    image: _pickedImage != null
                        ? DecorationImage(
                      image: FileImage(File(_pickedImage!.path)),
                      fit: BoxFit.cover,
                    )
                        : widget.product != null && widget.product!['image'] != null
                        ? DecorationImage(
                      image: widget.product!['image'].toString().startsWith('assets/')
                          ? AssetImage(widget.product!['image']) as ImageProvider
                          : FileImage(File(widget.product!['image'])),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _pickedImage == null &&
                      (widget.product == null || widget.product!['image'] == null)
                      ? Center(
                    child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey[700]),
                  )
                      : null,
                ),
              ),
              SizedBox(height: isMobile ? 12 : 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Please enter a name' : null,
              ),
              SizedBox(height: isMobile ? 12 : 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Please enter a price' : null,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: isMobile ? 12 : 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Please enter a category' : null,
              ),
              SizedBox(height: isMobile ? 12 : 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: isMobile ? 12 : 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.product == null ? 'Add Product' : 'Update Product'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
