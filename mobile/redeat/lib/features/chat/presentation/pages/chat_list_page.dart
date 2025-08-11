import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';
import 'chat_detail_page.dart';

class ChatListScreen extends StatefulWidget {
  final String currentUserId;

  const ChatListScreen({super.key, required this.currentUserId});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String? selectedUserId;

  // Hardcoded list of users for demo purposes
  final List<Map<String, String>> users = [
    {'id': 'user1', 'name': 'Alice'},
    {'id': 'user2', 'name': 'Bob'},
    {'id': 'user3', 'name': 'Charlie'},
    {'id': 'user4', 'name': 'Diana'},
  ];

  void _showInitiateChatDialog(BuildContext context) {
    setState(() {
      selectedUserId = null;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start New Chat'),
        content: DropdownButtonFormField<String>(
          value: selectedUserId,
          items: users
              .where((u) => u['id'] != widget.currentUserId) // exclude self
              .map((user) => DropdownMenuItem<String>(
            value: user['id'],
            child: Text(user['name']!),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedUserId = value;
            });
          },
          decoration: const InputDecoration(
            labelText: 'Select User',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: selectedUserId == null
                ? null
                : () {
              context.read<ChatBloc>().add(InitiateChat(selectedUserId!));
              Navigator.of(context).pop();
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
                    chatName: newChat.getName(widget.currentUserId),
                    currentUserId: widget.currentUserId,
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
                  final displayName = chat.getName(widget.currentUserId);
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
                            currentUserId: widget.currentUserId,
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
