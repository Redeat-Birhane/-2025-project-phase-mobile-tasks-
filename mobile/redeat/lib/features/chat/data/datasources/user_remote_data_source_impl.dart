import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';

import '../../../auth/data/models/user_model.dart';
import 'user_remote_data_source.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final Future<String> Function() tokenProvider;

  UserRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
    required this.tokenProvider,
  });

  @override
  Future<List<UserModel>> fetchAllUsers() async {
    final token = await tokenProvider();
    final url = Uri.parse('$baseUrl/users');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> usersList = jsonData['data'] ?? [];
      return usersList.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to fetch users');
    }
  }
}
