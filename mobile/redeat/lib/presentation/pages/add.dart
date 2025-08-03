import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/helpers.dart';
import '../../data/datasources/product_local_data_source_impl.dart';
import '../../data/datasources/product_remote_datasource_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/insert_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../data/repositories/product_repository_impl.dart';

class AddUpdatePage extends StatefulWidget {
  final Product? product;

  AddUpdatePage({this.product, Key? key}) : super(key: key);

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

  InsertProductUsecase? _insertProductUsecase;
  UpdateProductUsecase? _updateProductUsecase;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initUsecases();

    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _imageUrlController = TextEditingController(text: widget.product?.imageUrl ?? '');
  }

  Future<void> _initUsecases() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final localDataSource = ProductLocalDataSourceImpl(sharedPreferences: sharedPreferences);
    final remoteDataSource = ProductRemoteDataSourceImpl(client: http.Client());
    final repository = ProductRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );

    _insertProductUsecase = InsertProductUsecase(repository);
    _updateProductUsecase = UpdateProductUsecase(repository);

    setState(() {
      _isLoading = false;
    });
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

    if (_insertProductUsecase == null || _updateProductUsecase == null) {
      return;
    }

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final description = _descriptionController.text.trim();
    final imageUrl = _imageUrlController.text.trim();

    if (widget.product == null) {
      final newProduct = Product(
        id: _uuid.v4(),
        name: name,
        description: description,
        imageUrl: imageUrl.isEmpty ? AppStrings.defaultImageUrl : imageUrl,
        price: price,
      );
      await _insertProductUsecase!.call(newProduct);
      Navigator.pop(context, newProduct);
    } else {
      final updatedProduct = widget.product!.copyWith(
        name: name,
        description: description,
        imageUrl: imageUrl.isEmpty ? AppStrings.defaultImageUrl : imageUrl,
        price: price,
      );
      await _updateProductUsecase!.call(updatedProduct);
      Navigator.pop(context, updatedProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.product == null ? 'Add Product' : 'Update Product')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.product == null ? 'Add Product' : 'Update Product')),
      body: Padding(
        padding: EdgeInsets.all(mobile ? 16 : 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) => (value == null || value.isEmpty) ? AppStrings.enterNameError : null,
              ),
              SizedBox(height: mobile ? 12 : 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || value.isEmpty) ? AppStrings.enterPriceError : null,
              ),
              SizedBox(height: mobile ? 12 : 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: mobile ? 12 : 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              SizedBox(height: mobile ? 12 : 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.product == null ? 'Add Product' : 'Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
