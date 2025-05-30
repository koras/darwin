import 'package:flutter/material.dart';

Widget buildRoundedButton(
  BuildContext context,
  String text,
  VoidCallback onPressed,
) {
  final Color textColor = const Color.fromARGB(255, 122, 80, 0);
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.25,
    ),
    child: Material(
      borderRadius: BorderRadius.circular(30),
      elevation: 5,
      child: Container(
        width: double.infinity, // Занимает всю доступную ширину
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
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
    ),
  );
}
