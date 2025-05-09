import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // Для использования firstWhereOrNull

class LevelCompleteBanner extends StatelessWidget {
  final String itemName;
  final String imagePath;
  final VoidCallback onNextLevel;
  final VoidCallback onMainMenu;

  const LevelCompleteBanner({
    Key? key,
    required this.itemName,
    required this.imagePath,
    required this.onNextLevel,
    required this.onMainMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Уровень пройден!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 10),
            Text('Вы нашли: $itemName', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Image.asset(imagePath, width: 80, height: 80),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onMainMenu,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                  ),
                  child: const Text('В меню'),
                ),
                ElevatedButton(
                  onPressed: onNextLevel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Следующий уровень'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
