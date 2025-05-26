import 'package:flutter/material.dart';
import 'package:darwin/screens/mainMenu.dart';
import 'package:darwin/screens/showMerge.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darwin/bloc/level_bloc.dart';
import 'package:darwin/screens/feedback_screen.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Иконка Домой
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Действие при нажатии на домой

              print('Действие при нажатии Статистика');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StartPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Действие при нажатии на домой
              final currentState = context.read<LevelBloc>().state;
              print('Действие при нажатии Статистика');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CombinationsPage(
                        // Ваш список правил соединений
                        discoveredItems:
                            currentState.discoveredItems, // Открытые элементы
                      ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.feedback),
            onPressed: () {
              // Действие при нажатии на домой
              final currentState = context.read<LevelBloc>().state;
              print('Действие при нажатии Статистика');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => FeedbackScreen(
                        // Ваш список правил соединений
                      ),
                ),
              );
            },
          ),

          // Иконка Выключить звук
          IconButton(
            icon: const Icon(Icons.volume_off),
            onPressed: () {
              // Действие при выключении звука
            },
          ),
        ],
      ),
    );
  }
}
