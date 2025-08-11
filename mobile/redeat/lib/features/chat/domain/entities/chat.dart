import '../../../auth/domain/entities/user.dart';


class Chat {
  final String id;
  final User user1;
  final User user2;
  final String? lastMessage;
  final int? unreadCount;

  Chat({
    required this.id,
    required this.user1,
    required this.user2,
    this.lastMessage,
    this.unreadCount,
  });


  String getName(String currentUserId) {
    if (user1.id == currentUserId) {
      return user2.name ?? user2.email ?? "Unknown";
    } else {
      return user1.name ?? user1.email ?? "Unknown";
    }
  }
}
