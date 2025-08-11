enum MessageStatus { sending, sent, failed }

class Message {
  final String id;
  final String chatId;
  final String content;
  final String senderId;
  final DateTime timestamp;
  final MessageStatus status;

  Message({
    required this.id,
    required this.chatId,
    required this.content,
    required this.senderId,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });

  Message copyWith({
    String? id,
    MessageStatus? status,
    String? content,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId,
      content: content ?? this.content,
      senderId: senderId,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  bool isMe(String currentUserId) => senderId == currentUserId;
}
