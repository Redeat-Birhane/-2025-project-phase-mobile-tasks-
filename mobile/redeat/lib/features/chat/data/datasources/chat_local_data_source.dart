abstract class ChatLocalDataSource {
  Future<void> cacheChats(List chats);
  Future<List> getCachedChats();
}
