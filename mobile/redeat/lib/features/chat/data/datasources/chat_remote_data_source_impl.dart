import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../../core/constants/api_constants.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'chat_remote_data_source.dart';
import '../../../../core/error/exceptions.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final Future<String> Function() tokenProvider;

  late IO.Socket _socket;
  final StreamController<MessageModel> _messageController = StreamController.broadcast();

  ChatRemoteDataSourceImpl({
    required this.client,
    required this.tokenProvider,
  });

  @override
  Future<List<ChatModel>> fetchChatList() async {
    final token = await tokenProvider();
    final url = Uri.parse(ApiConstants.chats);
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
    final url = Uri.parse('${ApiConstants.chats}/$chatId/messages');
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
    final url = Uri.parse(ApiConstants.chats);
    print('POST $url with userId=$userId');
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'userId': userId}),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return ChatModel.fromJson(jsonData['data']);
    } else {
      throw ServerException(
        message: 'Failed to initiate chat: HTTP ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final token = await tokenProvider();
    final url = Uri.parse('${ApiConstants.chats}/$chatId');
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


    final socketUrl = ApiConstants.baseUrlV3.replaceAll('/api/v3', '');

    _socket = IO.io(
      socketUrl,
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
