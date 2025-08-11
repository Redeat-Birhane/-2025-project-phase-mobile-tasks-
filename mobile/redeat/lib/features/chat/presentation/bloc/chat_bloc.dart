import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/delete_chat_usecase.dart';
import '../../domain/usecases/get_chat_list_usecase.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/initiate_chat_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/repositories/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final GetChatListUseCase getChatListUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final DeleteChatUseCase deleteChatUseCase;
  final InitiateChatUseCase initiateChatUseCase;

  late final StreamSubscription<Message> _messageSubscription;

  final _uuid = Uuid();

  ChatBloc({
    required this.chatRepository,
    required this.getChatListUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.deleteChatUseCase,
    required this.initiateChatUseCase,
  }) : super(ChatInitial()) {
    on<LoadChatList>(_onLoadChatList);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<_NewMessageReceived>(_onNewMessageReceived);
    on<DeleteChat>(_onDeleteChat);
    on<InitiateChat>(_onInitiateChat);

    _messageSubscription = chatRepository.messageStream.listen((message) {
      add(_NewMessageReceived(message));
    });

    chatRepository.connectSocket();
  }

  Future<void> _onLoadChatList(
      LoadChatList event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final chats = await getChatListUseCase();
      emit(ChatListLoaded(chats));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onLoadMessages(
      LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await getMessagesUseCase(event.chatId);
      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    if (state is MessagesLoaded) {
      final currentMessages = List<Message>.from((state as MessagesLoaded).messages);


      final tempMessage = Message(
        id: _uuid.v4(),
        chatId: event.chatId,
        content: event.content,
        senderId: event.senderId,
        timestamp: DateTime.now(),
        status: MessageStatus.sending,
      );


      currentMessages.add(tempMessage);
      emit(MessagesLoaded(currentMessages));

      try {
        await sendMessageUseCase(event.chatId, event.content, event.type);

      } catch (e) {

        final failedMessages = currentMessages.map((msg) {
          if (msg.id == tempMessage.id) {
            return msg.copyWith(status: MessageStatus.failed);
          }
          return msg;
        }).toList();
        emit(MessagesLoaded(failedMessages));
      }
    }
  }

  void _onNewMessageReceived(
      _NewMessageReceived event, Emitter<ChatState> emit) {
    if (state is MessagesLoaded) {
      final currentMessages = List<Message>.from((state as MessagesLoaded).messages);


      final index = currentMessages.indexWhere((msg) =>
      msg.id == event.message.id ||
          (msg.status == MessageStatus.sending &&
              msg.content == event.message.content &&
              msg.senderId == event.message.senderId));

      if (index != -1) {

        currentMessages[index] = event.message.copyWith(status: MessageStatus.sent);
      } else {

        currentMessages.add(event.message);
      }

      emit(MessagesLoaded(currentMessages));
    }
  }

  Future<void> _onDeleteChat(
      DeleteChat event, Emitter<ChatState> emit) async {
    try {
      await deleteChatUseCase(event.chatId);
      add(LoadChatList());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onInitiateChat(
      InitiateChat event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final chat = await initiateChatUseCase(event.userId);
      add(LoadChatList());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _messageSubscription.cancel();
    chatRepository.disconnectSocket();
    return super.close();
  }
}
