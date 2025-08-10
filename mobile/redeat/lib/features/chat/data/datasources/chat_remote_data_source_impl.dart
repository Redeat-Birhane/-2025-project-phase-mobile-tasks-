import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'chat_remote_data_source.dart';
import '../../../../core/error/exceptions.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final Future<String> Function() tokenProvider;

  late IO.Socket _socket;
  final StreamController<MessageModel> _messageController = StreamController.broadcast();

  ChatRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
    required this.tokenProvider,
  });

  @override
  Future<List<ChatModel>> fetchChatList() async {
    final token = await tokenProvider();
    final url = Uri.parse('$baseUrl/chats');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> dataList = jsonData['data'] ?? [];
      return dataList.map((json) => ChatModel.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to fetch chat list');
    }
  }

  @override
  Future<List<MessageModel>> fetchMessages(String chatId) async {
    final token = await tokenProvider();
    final url = Uri.parse('$baseUrl/chats/$chatId/messages');
    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> dataList = jsonData['data'] ?? [];
      return dataList.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to fetch messages');
    }
  }

  @override
  Future<void> sendMessage(String chatId, String content, String type) async {
    final token = await tokenProvider();
    if (!_socket.connected) {
      connectSocket();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    final payload = {
      "chatId": chatId,
      "content": content,
      "type": type,
    };

    _socket.emit('message:send', payload);
  }

  @override
  Future<ChatModel> initiateChat(String userId) async {
    final token = await tokenProvider();
    final url = Uri.parse('$baseUrl/chats');
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return ChatModel.fromJson(jsonData['data']);
    } else {
      throw ServerException(message: 'Failed to initiate chat');
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final token = await tokenProvider();
    final url = Uri.parse('$baseUrl/chats/$chatId');
    final response = await client.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw ServerException(message: 'Failed to delete chat');
    }
  }

  @override
  void connectSocket() async {
    final token = await tokenProvider();

    _socket = IO.io(
      baseUrl.replaceAll('/api/v3', ''),
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket.on('connect', (_) {
      print('Socket connected');
    });

    _socket.on('disconnect', (_) {
      print('Socket disconnected');
    });

    _socket.on('message:received', (data) {
      final message = MessageModel.fromJson(data);
      _messageController.add(message);
    });
  }

  @override
  void disconnectSocket() {
    _socket.disconnect();
    _messageController.close();
  }

  Stream<MessageModel> get messageStream => _messageController.stream;
}
