import '../../../auth/domain/entities/user.dart';
import 'chat.dart';

class Message {
  final String id;
  final User sender;
  final Chat chat;
  final String content;
  final String type;

  Message({
    required this.id,
    required this.sender,
    required this.chat,
    required this.content,
    required this.type,
  });

  bool isMe(String currentUserId) {
    return sender.id == currentUserId;
  }


}
