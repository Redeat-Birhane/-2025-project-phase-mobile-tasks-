import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/message.dart';
import 'chat_model.dart';

class MessageModel {
  final String id;
  final UserModel sender;
  final ChatModel chat;
  final String content;
  final String type;

  MessageModel({
    required this.id,
    required this.sender,
    required this.chat,
    required this.content,
    required this.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      sender: UserModel.fromJson(json['sender']),
      chat: ChatModel.fromJson(json['chat']),
      content: json['content'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Message toEntity() {
    return Message(
      id: id,
      sender: sender.toEntity(),
      chat: chat.toEntity(),
      content: content,
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': sender.toJson(),
      'chat': chat.toJson(),
      'content': content,
      'type': type,
    };
  }
}
