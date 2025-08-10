import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call(String chatId, String content, String type) async {
    return await repository.sendMessage(chatId, content, type);
  }
}
