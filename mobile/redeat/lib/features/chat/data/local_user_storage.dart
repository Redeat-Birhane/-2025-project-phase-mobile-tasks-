import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalUserStorage {
  static const _keyRegisteredUsers = 'registered_users';


  static Future<void> addRegisteredUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_keyRegisteredUsers);
    List<dynamic> users = usersJson != null ? json.decode(usersJson) : [];


    final existingIndex = users.indexWhere((u) => u['id'] == user['id']);
    if (existingIndex >= 0) {
      users[existingIndex] = user;
    } else {
      users.add(user);
    }

    await prefs.setString(_keyRegisteredUsers, json.encode(users));
  }


  static Future<List<Map<String, dynamic>>> getRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_keyRegisteredUsers);
    if (usersJson == null) return [];
    final List<dynamic> users = json.decode(usersJson);
    return users.cast<Map<String, dynamic>>();
  }


  static Future<void> clearUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRegisteredUsers);
  }
}
