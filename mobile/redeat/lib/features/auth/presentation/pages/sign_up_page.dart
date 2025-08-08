import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String? _name;

  void _onSignUpButtonPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      context.read<AuthBloc>().add(SignedUp(email: _email, password: _password, name: _name));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            final username = state.user.name ?? '';
            Navigator.pushReplacementNamed(
              context,
              '/home',
              arguments: {'userName': username},
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Name (optional)'),
                      onSaved: (val) => _name = val,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (val) => val != null && val.contains('@') ? null : 'Invalid email',
                      onSaved: (val) => _email = val ?? '',
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (val) => val != null && val.length >= 6 ? null : 'Password too short',
                      onSaved: (val) => _password = val ?? '',
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _onSignUpButtonPressed,
                      child: Text('Sign Up'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signin');
                      },
                      child: Text('Already have an account? Sign In'),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
