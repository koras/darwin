import 'package:flutter/material.dart';

Widget buildRoundedButton(String text, VoidCallback onPressed) {
  final Color textColor = const Color.fromARGB(255, 122, 80, 0);
  return Material(
    borderRadius: BorderRadius.circular(30),
    elevation: 5,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: textColor, width: 2),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.transparent, // заменили primary на backgroundColor
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    ),
  );
}
