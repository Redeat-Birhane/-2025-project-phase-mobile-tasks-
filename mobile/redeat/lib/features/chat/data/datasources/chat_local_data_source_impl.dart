import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'chat_local_data_source.dart';

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const cachedChatsKey = 'CACHED_CHATS';

  ChatLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheChats(List chats) async {
    final jsonString = json.encode(chats);
    await sharedPreferences.setString(cachedChatsKey, jsonString);
  }

  @override
  Future<List> getCachedChats() async {
    final jsonString = sharedPreferences.getString(cachedChatsKey);
    if (jsonString != null) {
      try {
        final List decoded = json.decode(jsonString);
        return decoded;
      } catch (_) {
        return [];
      }
    } else {
      return [];
    }
  }
}
