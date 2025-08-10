import 'package:flutter/material.dart';

class AppGatewayPage extends StatelessWidget {
  final String userName;

  const AppGatewayPage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Module')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chatList');
              },
              child: const Text('Chat'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/home',
                  arguments: {'userName': userName},
                );
              },
              child: const Text('Products'),
            ),
          ],
        ),
      ),
    );
  }
}
