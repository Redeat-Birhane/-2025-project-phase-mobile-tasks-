import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_strings.dart';
import '../../core/utils/helpers.dart';
import '../../data/datasources/product_local_data_source_impl.dart';
import '../../data/datasources/product_remote_datasource_impl.dart';
import '../../domain/entities/product.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/usecases/delete_product_usecase.dart';

class DetailsPage extends StatelessWidget {
  final Product product;

  DetailsPage({required this.product});

  Future<void> _delete(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final localDataSource = ProductLocalDataSourceImpl(sharedPreferences: sharedPreferences);
    final remoteDataSource = ProductRemoteDataSourceImpl(client: http.Client());
    final repository = ProductRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
    final deleteProductUsecase = DeleteProductUsecase(repository);

    await deleteProductUsecase.call(product.id);

    Navigator.pop(context, null); // Return null to signal deletion
  }

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.productDetailsTitle)),
      body: Padding(
        padding: EdgeInsets.all(mobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product-${product.id}',
              child: Container(
                height: mobile ? 200 : 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: mobile ? 20 : 24),
            Text(product.name, style: TextStyle(fontSize: mobile ? 22 : 26, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('\$${product.price}', style: TextStyle(fontSize: mobile ? 20 : 24, color: Colors.blue)),
            SizedBox(height: 24),
            Text(product.description, style: TextStyle(fontSize: mobile ? 16 : 18)),
            Spacer(),
            ElevatedButton(
              onPressed: () => _delete(context),
              child: Text(AppStrings.deleteProduct),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: mobile ? 14 : 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
