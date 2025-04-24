import 'package:flutter/material.dart';

import '../data/icons.dart';

class GamePanel extends StatelessWidget {
  final String name;
  final int stars;
  final String taskDescription;
  final String time;
  final VoidCallback onHintPressed;
  final VoidCallback onClearPressed;
  final String scoreImagePath;

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
      //  color: Colors.blueGrey[100],
      padding: EdgeInsets.only(left: 16.0, top: 40, right: 16.0),
      child: Column(
        children: [
          //    SizedBox(height: 40),
          // Верхняя строка с кнопками и заголовком
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //   SizedBox(height: 30),
              // Левая часть - картинка баллов и кнопка подсказки
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    // 👈 Оборачиваем Image.asset в GestureDetector
                    onTap: onHintPressed, // Вешаем обработчик
                    child: Image.asset(IconsGame.hint, height: 36),
                  ),
                ],
              ),

              // Центральная часть - заголовок задания
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    taskDescription,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              // Правая часть - время и кнопка очистки
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        stars.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Image.asset(
                        IconsGame.star,
                        height: 24, // Высота как у текста
                        width: 24, // Ширина как у текста
                      ),
                    ],
                  ),

                  SizedBox(height: 30),
                  GestureDetector(
                    // 👈 Оборачиваем Image.asset в GestureDetector
                    onTap: onClearPressed, // Вешаем обработчик
                    child: Image.asset(IconsGame.clear, height: 36),
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
