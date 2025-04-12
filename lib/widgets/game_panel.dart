import 'package:flutter/material.dart';

import '../models/image_item.dart';
import '../logic/game_field_manager.dart';
import 'toolbox_item.dart';

class GamePanel extends StatelessWidget {
  final String name;

  const GamePanel({required this.name, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2, // 20% высоты экрана
      color: Colors.blueGrey[100],
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
