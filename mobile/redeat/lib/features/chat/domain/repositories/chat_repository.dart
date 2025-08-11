import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/chat.dart';

abstract class ChatRepository {
  Future<List<Chat>> getChatList();
  Future<List<Message>> getMessages(String chatId);
  Future<void> sendMessage(String chatId, String content, String type);
  Future<Chat> initiateChat(String userId);
  Future<void> deleteChat(String chatId);


  void connectSocket();
  void disconnectSocket();

  Stream<Message> get messageStream;
}
