import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/data/local_user_storage.dart';
import '../bloc/chat_bloc.dart';
import 'chat_detail_page.dart';

class ChatListScreen extends StatefulWidget {
  final String currentUserId;

  const ChatListScreen({super.key, required this.currentUserId});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Map<String, dynamic>> registeredUsers = [];

  @override
  void initState() {
    super.initState();
    _loadRegisteredUsers();
    context.read<ChatBloc>().add(LoadChatList());
  }

  Future<void> _loadRegisteredUsers() async {
    final users = await LocalUserStorage.getRegisteredUsers();
    setState(() {
      registeredUsers = users
          .where((user) => user['id']?.toString() != widget.currentUserId)
          .toList();
    });
  }

  void _showInitiateChatDialog(BuildContext context) {
    String? selectedUserId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Start New Chat'),
          content: registeredUsers.isEmpty
              ? const Text('No registered users available.')
              : DropdownButtonFormField<String>(
            items: registeredUsers.map<DropdownMenuItem<String>>(
                    (Map<String, dynamic> user) {
                  final userId = user['id']?.toString() ?? '';
                  final userName = user['name']?.toString() ?? 'Unknown';
                  return DropdownMenuItem<String>(
                    value: userId,
                    child: Text(userName),
                  );
                }).toList(),
            onChanged: (value) {
              selectedUserId = value;
            },
            decoration: const InputDecoration(labelText: 'Select a user'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedUserId != null && selectedUserId!.isNotEmpty) {
                  context.read<ChatBloc>().add(InitiateChat(selectedUserId!));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Start'),
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
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatListLoaded) {
            final chats = state.chats;
            if (chats.isEmpty) {
              return const Center(child: Text('No chats found.'));
            }
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final displayName = chat.getName(widget.currentUserId);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInitiateChatDialog(context),
        child: const Icon(Icons.chat),
      ),
    );
  }
}
