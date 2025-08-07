import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthenticatedHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user;
          return Scaffold(
            appBar: AppBar(
              title: Text('Welcome, ${user.name ?? user.email}'),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    context.read<AuthBloc>().add(LoggedOut());
                  },
                )
              ],
            ),
            body: Center(
              child: Text('User ID: ${user.id}\nEmail: ${user.email}'),
            ),
          );
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
