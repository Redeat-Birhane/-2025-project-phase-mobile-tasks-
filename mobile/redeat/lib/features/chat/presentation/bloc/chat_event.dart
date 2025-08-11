part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessage extends ChatEvent {
  final String chatId;
  final String content;
  final String type;
  final String senderId;

  SendMessage(this.chatId, this.content, this.type, this.senderId);

  @override
  List<Object?> get props => [chatId, content, type, senderId];
}



class LoadChatList extends ChatEvent {}

class LoadMessages extends ChatEvent {
  final String chatId;
  LoadMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class DeleteChat extends ChatEvent {
  final String chatId;
  DeleteChat(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class InitiateChat extends ChatEvent {
  final String userId;
  InitiateChat(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadUserList extends ChatEvent {}
class _NewMessageReceived extends ChatEvent {
  final Message message;
  _NewMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}
