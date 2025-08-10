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

  Future<String> loginAndGetToken(String email, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrlV2}/auth/login');
    print('[AuthRemote] Login request → $url');
    print('Body: {email: $email, password: $password}');

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'email': email, 'password': password}),
    );

    print('Login Response: [${response.statusCode}] ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonMap = json.decode(response.body);
      final token = jsonMap['data']?['access_token'];
      if (token == null || token.isEmpty) {
        throw ServerException(message: 'Login failed: access token is missing');
      }
      return token;
    } else {
      throw ServerException(
          message:
          'Login failed: ${response.statusCode} ${response.reasonPhrase} ${response.body}');
    }
  }

  Future<User> getUserProfile(String token) async {
    final url = Uri.parse('${ApiConstants.baseUrlV2}/users/me');
    print('[AuthRemote] Get user profile request → $url');

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Get user profile Response: [${response.statusCode}] ${response.body}');

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      if (jsonMap['data'] == null) {
        print('[AuthRemote] Warning: Profile data is null');
        return User(id: '', name: '', email: '', token: token);
      }
      final user = UserModel.fromJson(jsonMap['data']);
      user.token = token;
      return user;
    } else {
      throw ServerException(
          message:
          'Failed to fetch user profile: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  @override
  Future<User> login(String email, String password) async {
    print('🌀 [AuthRemote] Login called');
    try {
      final token = await loginAndGetToken(email, password);
      final user = await getUserProfile(token);
      return user;
    } catch (e) {
      print('[AuthRemote] Login error: $e');
      rethrow;
    }
  }

  @override
  Future<User> signup(String email, String password, {String? name}) async {
    final url = Uri.parse('${ApiConstants.baseUrlV2}/auth/register');
    final body = {
      'email': email,
      'password': password,
      if (name != null) 'name': name,
    };

    print('[AuthRemote] Signup request → $url');
    print('Body: $body');

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(body),
    );

    print('Signup Response: [${response.statusCode}] ${response.body}');

    if (response.statusCode == 201) {
      print('Signup successful, logging in...');
      try {
        final token = await loginAndGetToken(email, password);
        final user = await getUserProfile(token);
        return user;
      } catch (e) {
        print('[AuthRemote] Login after signup error: $e');
        rethrow;
      }
    } else {
      print('Signup failed — throwing ServerException');
      throw ServerException(
          message:
          'Signup failed: ${response.statusCode} ${response.reasonPhrase} ${response.body}');
    }
  }

  @override
  Future<void> logout() async {
    print('[AuthRemote] Logout called — currently no server call implemented.');
  }
}
