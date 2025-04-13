import 'package:flutter/material.dart';

import '../data/icons.dart';

class GamePanel extends StatelessWidget {
  final String name;
  final int stars;
  final String taskDescription;
  final String time;
  final VoidCallback onHintPressed;
  final VoidCallback onClearPressed;
  final String scoreImagePath; // Путь к картинке для баллов

  const GamePanel({
    required this.name,
    required this.stars,

    required this.taskDescription,
    required this.time,
    required this.onHintPressed,
    required this.onClearPressed,
    required this.scoreImagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[100],
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Верхняя строка с кнопками и заголовком
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //      crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Левая часть - картинка баллов и кнопка подсказки
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        IconsGame.star,
                        height: 24, // Высота как у текста
                        width: 24, // Ширина как у текста
                      ),
                      Text(
                        stars.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Image.asset(
                    IconsGame.hint,
                    height: 36, // Высота как у текста
                    //   width: 36, // Ширина как у текста
                  ),
                ],
              ),

              // Центральная часть - заголовок задания
              Column(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    taskDescription,
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                ],
              ),

              // Правая часть - время и кнопка очистки
              Column(
                children: [
                  Text(
                    time,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Image.asset(
                    IconsGame.clear,
                    height: 36, // Высота как у текста
                    //    width: 50, // Ширина как у текста
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
