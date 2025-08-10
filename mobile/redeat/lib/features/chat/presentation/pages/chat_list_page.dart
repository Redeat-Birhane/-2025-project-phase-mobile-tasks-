import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import 'chat_detail_page.dart';
import '../../data/local_user_storage.dart';

class ChatListScreen extends StatelessWidget {
  final String currentUserId;

  const ChatListScreen({super.key, required this.currentUserId});

  void _showInitiateChatDialog(BuildContext context) async {
    final registeredUsers = await LocalUserStorage.getRegisteredUsers();

    if (registeredUsers.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('No Registered Users'),
          content: const Text('No users found to start a chat with.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Start New Chat'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: registeredUsers.length,
              itemBuilder: (context, index) {
                final user = registeredUsers[index];
                return ListTile(
                  title: Text(user['name'] ?? 'Unknown'),
                  subtitle: Text(user['email'] ?? ''),
                  onTap: () {
                    context.read<ChatBloc>().add(InitiateChat(user['id']));
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
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
                    leading: CircleAvatar(
                      child: Text(
                        displayName.isNotEmpty
                            ? displayName.substring(0, 1).toUpperCase()
                            : '?',
                      ),
                    ),
                    title: Text(displayName.isNotEmpty ? displayName : 'Unknown'),
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
                            chatName: displayName.isNotEmpty ? displayName : 'Unknown',
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
