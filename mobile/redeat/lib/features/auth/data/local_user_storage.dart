import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserStorage {
  static const String _usersKey = 'registered_users';

  static Future<List<Map<String, dynamic>>> getRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_usersKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<void> addRegisteredUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getRegisteredUsers();

    final exists = users.any((u) => u['id'] == user['id'] || u['email'] == user['email']);
    if (!exists) {
      users.add(user);
      await prefs.setString(_usersKey, json.encode(users));
    }
  }
}
