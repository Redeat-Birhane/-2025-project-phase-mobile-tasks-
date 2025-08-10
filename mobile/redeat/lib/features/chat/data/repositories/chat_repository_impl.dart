import '../../domain/entities/message.dart';
import '../../domain/entities/chat.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Chat>> getChatList() async {
    final chatModels = await remoteDataSource.fetchChatList();
    return chatModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Message>> getMessages(String chatId) async {
    final messageModels = await remoteDataSource.fetchMessages(chatId);
    return messageModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> sendMessage(String chatId, String content, String type) {
    return remoteDataSource.sendMessage(chatId, content, type);
  }

  @override
  Future<Chat> initiateChat(String userId) async {
    final chatModel = await remoteDataSource.initiateChat(userId);
    return chatModel.toEntity();
  }

  @override
  Future<void> deleteChat(String chatId) {
    return remoteDataSource.deleteChat(chatId);
  }

  @override
  void connectSocket() {
    remoteDataSource.connectSocket();
  }

  @override
  void disconnectSocket() {
    remoteDataSource.disconnectSocket();
  }

  @override
  Stream<Message> get messageStream =>
      remoteDataSource.messageStream.map((model) => model.toEntity());
}
