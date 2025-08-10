import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import 'chat_detail_page.dart';

class ChatListScreen extends StatelessWidget {
  final String currentUserId;

  const ChatListScreen({super.key, required this.currentUserId});

  void _showInitiateChatDialog(BuildContext context) {
    final TextEditingController _userIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start New Chat'),
        content: TextField(
          controller: _userIdController,
          decoration: const InputDecoration(hintText: 'Enter User ID'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final userId = _userIdController.text.trim();
              if (userId.isNotEmpty) {
                context.read<ChatBloc>().add(InitiateChat(userId));
                Navigator.of(context).pop();
              }
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatListLoaded) {
            final newChat = state.chats.isNotEmpty ? state.chats.last : null;
            if (newChat != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailScreen(
                    chatId: newChat.id,
                    chatName: newChat.getName(currentUserId),
                    currentUserId: currentUserId,
                  ),
                ),
              );
            }
          }
        },
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatListLoaded) {
              final chats = state.chats;
              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final displayName = chat.getName(currentUserId);
                  return ListTile(
                    leading: CircleAvatar(child: Text(displayName.substring(0, 1))),
                    title: Text(displayName),
                    subtitle: Text(chat.lastMessage ?? ''),
                    trailing: (chat.unreadCount ?? 0) > 0
                        ? CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue,
                      child: Text(
                        (chat.unreadCount ?? 0).toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatDetailScreen(
                            chatId: chat.id,
                            chatName: displayName,
                            currentUserId: currentUserId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is ChatError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInitiateChatDialog(context),
        child: const Icon(Icons.chat),
      ),
    );
  }
}
