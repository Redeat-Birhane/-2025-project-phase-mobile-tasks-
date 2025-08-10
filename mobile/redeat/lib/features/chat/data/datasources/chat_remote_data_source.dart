import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> fetchChatList();
  Future<List<MessageModel>> fetchMessages(String chatId);
  Future<void> sendMessage(String chatId, String content, String type);
  Future<ChatModel> initiateChat(String userId);
  Future<void> deleteChat(String chatId);

  void connectSocket();
  void disconnectSocket();

  Stream<MessageModel> get messageStream;  // Add this line!
}
