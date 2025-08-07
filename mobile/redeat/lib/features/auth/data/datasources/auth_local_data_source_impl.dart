import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user.dart';
import 'auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(User user) {
    final userJson = json.encode({
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'token': user.token,
    });
    return sharedPreferences.setString(cachedUserKey, userJson);
  }

  @override
  Future<User?> getCachedUser() {
    final jsonString = sharedPreferences.getString(cachedUserKey);
    if (jsonString != null) {
      final Map<String, dynamic> userMap = json.decode(jsonString);
      return Future.value(User(
        id: userMap['id'],
        email: userMap['email'],
        name: userMap['name'],
        token: userMap['token'],
      ));
    } else {
      return Future.value(null);
    }
  }

  @override
  Future<void> clearCache() {
    return sharedPreferences.remove(cachedUserKey);
  }
}
