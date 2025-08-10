part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatList extends ChatEvent {}

class LoadMessages extends ChatEvent {
  final String chatId;

  LoadMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SendMessage extends ChatEvent {
  final String chatId;
  final String content;
  final String type;

  SendMessage(this.chatId, this.content, this.type);

  @override
  List<Object?> get props => [chatId, content, type];
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


