import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user.dart';
import 'auth_remote_data_source.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<User> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrlV2}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return UserModel.fromJson(jsonMap['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<User> signup(String email, String password, {String? name}) async {
    final body = {
      'email': email,
      'password': password,
      if (name != null) 'name': name,
    };
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrlV2}/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 201) {
      final jsonMap = json.decode(response.body);
      return UserModel.fromJson(jsonMap['data']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    // If API supports logout call, implement it here; else just clear locally.
    // Example:
    // final response = await client.post(Uri.parse('${ApiConstants.baseUrlV2}/auth/logout'));
    // if (response.statusCode != 204) throw ServerException();
  }
}
