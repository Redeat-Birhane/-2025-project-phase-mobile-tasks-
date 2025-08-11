import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/message.dart';
import 'chat_model.dart';

class MessageModel {
  final String id;
  final UserModel sender;
  final ChatModel chat;
  final String content;
  final String type;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.sender,
    required this.chat,
    required this.content,
    required this.type,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      sender: UserModel.fromJson(json['sender']),
      chat: ChatModel.fromJson(json['chat']),
      content: json['content'] ?? '',
      type: json['type'] ?? '',
      timestamp: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Message toEntity() {
    return Message(
      id: id,
      chatId: chat.id,
      content: content,
      senderId: sender.id,
      timestamp: timestamp,
      status: MessageStatus.sent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': sender.toJson(),
      'chat': chat.toJson(),
      'content': content,
      'type': type,
      'createdAt': timestamp.toIso8601String(),
    };
  }
}
