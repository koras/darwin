import 'package:darwin/models/game_item.dart';

import 'package:darwin/models/image_item.dart';

import 'package:flutter/material.dart';

class HintBanner extends StatelessWidget {
  final String item1Id;
  final String item2Id;
  final String resultId;
  final VoidCallback onClose;

  const HintBanner({
    Key? key,
    required this.item1Id,
    required this.item2Id,
    required this.resultId,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Получаем данные элементов из вашего репозитория
    final item1new = allImages.firstWhere((i) => i.id == item1Id);
    final item1 = GameItem.fromImageItem(imageItem: item1new);

    final item2new = allImages.firstWhere((i) => i.id == item2Id);
    final item2 = GameItem.fromImageItem(imageItem: item2new);

    final resultnew = allImages.firstWhere((i) => i.id == resultId);
    final result = GameItem.fromImageItem(imageItem: resultnew);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Заголовок
              const Text(
                'Подсказка',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),

              // Комбинация элементов
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Первый элемент
                  _buildItemWidget(item1),

                  // Плюс
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text(
                      '+',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  // Второй элемент
                  _buildItemWidget(item2),

                  // Равно
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text(
                      '=',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  // Результат
                  _buildItemWidget(result),
                ],
              ),
              const SizedBox(height: 20),

              // Кнопка закрытия
              ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                ),
                child: const Text('Понятно', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemWidget(GameItem item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _generateCalmColor(item.id), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(item.assetPath, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          item.id,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Color _generateCalmColor(String input) {
    final hash = input.hashCode;
    return HSLColor.fromAHSL(1.0, (hash % 360).toDouble(), 0.4, 0.7).toColor();
  }
}
