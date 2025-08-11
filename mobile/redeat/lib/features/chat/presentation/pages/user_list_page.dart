import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';

class UserListPage extends StatelessWidget {
  final String currentUserId;

  const UserListPage({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    context.read<ChatBloc>().add(LoadUserList());

    return Scaffold(
      appBar: AppBar(title: const Text('Select User to Chat')),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserListLoaded) {
            final users = state.users.where((u) => u.id != currentUserId).toList();

            if (users.isEmpty) {
              return const Center(child: Text('No other users found.'));
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name ?? user.email),
                  subtitle: Text(user.email),
                  onTap: () {
                    context.read<ChatBloc>().add(InitiateChat(user.id));
                    Navigator.pop(context);
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
    );
  }
}
