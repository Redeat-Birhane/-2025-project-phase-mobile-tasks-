import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetChatListUseCase {
  final ChatRepository repository;

  GetChatListUseCase(this.repository);

  Future<List<Chat>> call() async {
    return await repository.getChatList();
  }
}
