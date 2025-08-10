import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetMessagesUseCase {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  Future<List<Message>> call(String chatId) async {
    return await repository.getMessages(chatId);
  }
}
