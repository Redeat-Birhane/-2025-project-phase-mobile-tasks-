import '../../../auth/domain/entities/user.dart';

class Chat {
  final String id;
  final User user1;
  final User user2;

  final String? lastMessage;
  final int unreadCount;

  Chat({
    required this.id,
    required this.user1,
    required this.user2,
    this.lastMessage,
    this.unreadCount = 0,
  });



  String getName(String currentUserId) {
    if (user1.id == currentUserId) return user2.name ?? 'Unknown';
    return user1.name ?? 'Unknown';
  }
}
