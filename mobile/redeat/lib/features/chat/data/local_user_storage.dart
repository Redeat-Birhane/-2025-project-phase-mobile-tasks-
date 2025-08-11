import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalUserStorage {
  static const String _usersKey = 'registered_users';


  static Future<void> saveUser(String id, String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    List<Map<String, String>> users = [];

    if (usersJson != null) {
      users = List<Map<String, String>>.from(jsonDecode(usersJson));
    }


    final existingIndex = users.indexWhere((u) => u['id'] == id);

    if (existingIndex != -1) {

      users[existingIndex] = {'id': id, 'name': name, 'email': email};
    } else {

      users.add({'id': id, 'name': name, 'email': email});
    }

    await prefs.setString(_usersKey, jsonEncode(users));
  }

  /// Get all registered users
  static Future<List<Map<String, String>>> getRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson != null) {
      return List<Map<String, String>>.from(jsonDecode(usersJson));
    }
    return [];
  }

  /// Clear all users (for testing/debug)
  static Future<void> clearUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usersKey);
  }
}
