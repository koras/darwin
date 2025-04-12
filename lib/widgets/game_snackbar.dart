import 'package:flutter/material.dart';

class GameSnackbar {
  static void show(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.deepPurple,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
