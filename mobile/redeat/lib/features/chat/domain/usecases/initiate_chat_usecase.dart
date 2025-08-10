import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class InitiateChatUseCase {
  final ChatRepository repository;

  InitiateChatUseCase(this.repository);

  Future<Chat> call(String userId) async {
    return await repository.initiateChat(userId);
  }
}
