import 'package:flutter/material.dart';
import '../screens/mainMenu.dart';

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
