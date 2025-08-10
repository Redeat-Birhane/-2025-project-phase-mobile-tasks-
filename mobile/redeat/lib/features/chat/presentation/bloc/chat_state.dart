part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatListLoaded extends ChatState {
  final List<Chat> chats;
  const ChatListLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class MessagesLoaded extends ChatState {
  final List<Message> messages;
  const MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
