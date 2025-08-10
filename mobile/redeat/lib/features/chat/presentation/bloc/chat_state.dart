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

  ChatListLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class MessagesLoaded extends ChatState {
  final List<Message> messages;

  MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);

  @override
  List<Object?> get props => [message];
}


class UserListLoaded extends ChatState {
  final List<User> users;

  UserListLoaded(this.users);

  @override
  List<Object?> get props => [users];
}
