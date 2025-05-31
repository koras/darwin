import 'package:flutter/material.dart';

import 'package:darwin/constants/icons.dart';
import 'package:darwin/constants/colors.dart';
import 'package:darwin/gen_l10n/app_localizations.dart';
import 'package:darwin/bloc/level_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePanel extends StatelessWidget {
  final String name;
  final int stars;
  final String taskDescription;
  final String time;
  final VoidCallback onHintPressed;
  final VoidCallback onClearPressed;
  // final String scoreImagePath;
  final Animation<double>? clearButtonAnimation; // Добавляем параметр анимации

  const GamePanel({
    required this.name,
    required this.stars,
    required this.taskDescription,
    required this.time,
    required this.onHintPressed,
    required this.onClearPressed,
    //  required this.scoreImagePath,
    super.key,
    this.clearButtonAnimation,
  });

  @override
  Widget build(BuildContext context) {
    int level = context.read<LevelBloc>().state.currentLevel;
    int hints =
        context.read<LevelBloc>().state.hintsState.freeHints +
        context.read<LevelBloc>().state.hintsState.paidHintsAvailable;
    String textHints = AppLocalizations.of(context)!.textHints;
    String textLevels = AppLocalizations.of(context)!.textLevels;

    String textHits = time;
    print('time $time');

    if (time == '' || time == '00:00') {
      textHits = '$textHints: $hints';
    }

    //   time;
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
              Container(
                width: 150, // или любая другая фиксированная ширина
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      //    width: 80,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      // decoration: BoxDecoration(
                      //   color: AppColors.borderBackGround,
                      //   border: Border.all(
                      //     color:
                      //         AppColors
                      //             .borderHint, // немного темнее желтый для бордюра
                      //     width: 2, // толщина бордюрчика
                      //   ),
                      //   borderRadius: BorderRadius.circular(4), // закругление
                      // ),
                      child: Text(
                        textHits, // здесь level - переменная, которую нужно передать
                        style: TextStyle(
                          fontSize: AppInfo.infoText,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Text(
                    //   time,
                    //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    // ),
                    SizedBox(height: 15),
                    GestureDetector(
                      // 👈 Оборачиваем Image.asset в GestureDetector
                      onTap: onHintPressed, // Вешаем обработчик
                      child: Image.asset(IconsGame.hint, height: 36),
                    ),
                  ],
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              //   decoration: BoxDecoration(
              //     color: Colors.yellow.shade700,
              //     border: Border.all(
              //       color: const Color.fromARGB(
              //         255,
              //         160,
              //         125,
              //         0,
              //       ), // немного темнее желтый для бордюра
              //       width: 2, // толщина бордюрчика
              //     ),
              //     borderRadius: BorderRadius.circular(4), // закругление
              //   ),
              //   child: Text(
              //     'level $level', // здесь level - переменная, которую нужно передать
              //     style: TextStyle(fontSize: 13, color: Colors.black),
              //   ),
              // ),

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
                      color: AppColors.colorGameinfo,
                    ),
                  ),
                ],
              ),

              // Правая часть - время и кнопка очистки
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   children: [
                  //     SizedBox(height: 30),
                  //     Text(
                  //       stars.toString(),
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.black87,
                  //       ),
                  //     ),
                  //     Image.asset(
                  //       IconsGame.star,
                  //       height: 24, // Высота как у текста
                  //       width: 24, // Ширина как у текста
                  //     ),
                  //   ],
                  // ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    // decoration: BoxDecoration(
                    //   color: AppColors.borderBackGround,
                    //   border: Border.all(
                    //     color:
                    //         AppColors
                    //             .borderHint, // немного темнее желтый для бордюра
                    //     width: 2, // толщина бордюрчика
                    //   ),
                    //   borderRadius: BorderRadius.circular(4), // закругление
                    // ),
                    child: Text(
                      '$textLevels: $level', // здесь level - переменная, которую нужно передать
                      style: TextStyle(
                        fontSize: AppInfo.infoText,
                        color: AppColors.colorGameinfo,
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  // GestureDetector(
                  //   // 👈 Оборачиваем Image.asset в GestureDetector
                  //   onTap: onClearPressed, // Вешаем обработчик
                  //   child: Image.asset(IconsGame.clear, height: 36),
                  // ),
                  // ScaleTransition(
                  //   scale: clearButtonAnimation ?? AlwaysStoppedAnimation(1.0),
                  //   child: IconButton(
                  //     icon: Icon(Icons.delete),
                  //     onPressed: onClearPressed,
                  //   ),
                  // ),
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
