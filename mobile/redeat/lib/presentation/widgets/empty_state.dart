import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;

  const EmptyState({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 600;
    return Center(
      child: Text(
        message,
        style: TextStyle(fontSize: mobile ? 16 : 20),
      ),
    );
  }
}
