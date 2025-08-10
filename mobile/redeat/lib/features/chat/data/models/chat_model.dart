import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/chat.dart';

class ChatModel {
  final String id;
  final UserModel user1;
  final UserModel user2;

  ChatModel({
    required this.id,
    required this.user1,
    required this.user2,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      user1: UserModel.fromJson(json['user1']),
      user2: UserModel.fromJson(json['user2']),
    );
  }

  Chat toEntity() {
    return Chat(
      id: id,
      user1: user1.toEntity(),
      user2: user2.toEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user1': user1.toJson(),
      'user2': user2.toJson(),
    };
  }
}
