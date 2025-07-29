import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/domain/entities/product.dart';

class AddUpdatePage extends StatefulWidget {
  final Product? product;
  final Function(Product)? onSave;
  final Function()? onDelete;

  const AddUpdatePage({
    super.key,
    this.product,
    this.onSave,
    this.onDelete,
  });

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descriptionController;

  double _rating = 0;
  List<int> _sizes = [39, 40, 41, 42, 43, 44];
  List<bool> _selectedSizes = List.filled(6, false);

  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController =
        TextEditingController(text: widget.product?.price.toString() ?? '');
    _categoryController =
        TextEditingController(text: widget.product?.category ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    _rating = widget.product?.rating ?? 0;
    _sizes = widget.product?.sizes ?? [39, 40, 41, 42, 43, 44];

    if (widget.product?.sizes != null) {
      _selectedSizes = List.generate(6, (index) {
        return widget.product!.sizes.contains(39 + index);
      });
    }
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final selectedSizes = <int>[];
      for (var i = 0; i < _selectedSizes.length; i++) {
        if (_selectedSizes[i]) {
          selectedSizes.add(39 + i);
        }
      }

      final productData = Product(
        id: widget.product?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        category: _categoryController.text.trim(),
        rating: _rating,
        description: _descriptionController.text.trim(),
        sizes: selectedSizes,
        imageUrl: _pickedImage?.path ??
            widget.product?.imageUrl ??
            'assets/images/shoe.jpg',
      );

      widget.onSave?.call(productData);
      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Update Product'),
        actions: [
          if (widget.product != null && widget.onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(context),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          : widget.product != null
                          ? DecorationImage(
                        image: widget.product!.imageUrl
                            .startsWith('assets/')
                            ? AssetImage(widget.product!.imageUrl)
                            : FileImage(
                          File(widget.product!.imageUrl),
                        ) as ImageProvider,
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _pickedImage == null && widget.product == null
                        ? Center(
                      child: Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Colors.grey[700],
                      ),
                    )
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter a price';
                    if (double.tryParse(value!) == null) return 'Invalid price';
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter a category'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Sizes',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: List.generate(6, (index) {
                    final size = 39 + index;
                    return FilterChip(
                      label: Text(size.toString()),
                      selected: _selectedSizes[index],
                      onSelected: (selected) {
                        setState(() => _selectedSizes[index] = selected);
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _rating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  label: _rating.toStringAsFixed(1),
                  onChanged: (value) => setState(() => _rating = value),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: isMobile ? 14 : 16, horizontal: 20),
                  ),
                  child: Text(
                    widget.product == null ? 'Add Product' : 'Update Product',
                    style: TextStyle(fontSize: isMobile ? 16 : 18),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete?.call();
                Navigator.of(context).pop();
              },
              child: const Text(
                'DELETE',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
