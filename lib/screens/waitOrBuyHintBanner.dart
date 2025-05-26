import 'package:flutter/material.dart';
import 'package:darwin/models/game_item.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darwin/bloc/level_bloc.dart';

class WaitOrBuyHintBanner extends StatelessWidget {
  final Duration remainingTime;
  final VoidCallback onClose;

  final Function(int, int) onBuyHints;

  const WaitOrBuyHintBanner({
    Key? key,

    required this.remainingTime,
    required this.onClose,
    required this.onBuyHints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Получаем данные элементов
    // Форматируем оставшееся время
    final timeText = context.read<LevelBloc>().state.timeStr ?? '';
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width,
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
                'До следующей бесплатной подсказки',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Таймер
              Text(
                timeText,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 20),

              // Комбинация элементов (как в оригинальном баннере)

              // Текст предложения купить
              const Text(
                'Или купите подсказки сейчас:',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 15),

              // Кнопки покупки подсказок
              _buildPurchaseOption(
                context,
                '3 подсказок',
                '100 ₽',
                () => onBuyHints(3, 100),
                const Color.fromARGB(255, 214, 228, 253),
              ),
              const SizedBox(height: 10),

              _buildPurchaseOption(
                context,
                '5 подсказок',
                '200 ₽',
                () => onBuyHints(5, 200),
                const Color.fromARGB(255, 220, 240, 221),
              ),
              const SizedBox(height: 10),

              _buildPurchaseOption(
                context,
                '10 подсказок',
                '300 ₽',
                () => onBuyHints(10, 300),
                const Color.fromARGB(255, 247, 201, 255),
              ),
              const SizedBox(height: 10),

              _buildPurchaseOption(
                context,
                '20 подсказок',
                '500 ₽',
                () => onBuyHints(20, 500),
                const Color.fromARGB(255, 202, 201, 255),
              ),
              const SizedBox(height: 40),
              // Кнопка закрытия
              TextButton(
                onPressed: onClose,
                child: const Text(
                  'Продолжить без подсказок',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 25, 82, 32),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPurchaseOption(
    BuildContext context,
    String title,
    String price,
    VoidCallback onPressed,
    Color color,
  ) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width * 0.8, // Задаем ширину 80% экрана
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16, // Увеличили вертикальный padding
            horizontal: 24, // Добавили горизонтальный padding
          ),
          elevation: 3, // Добавили тень для кнопки
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:
              MainAxisSize.min, // Чтобы Row не растягивался на всю ширину
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18, // Увеличили размер текста
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(
                  255,
                  53,
                  53,
                  53,
                ), // Белый текст для лучшей читаемости
              ),
            ),
            const SizedBox(width: 12), // Увеличили отступ между текстами
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              child: Text(
                price,
                style: const TextStyle(
                  fontSize: 18, // Увеличили размер текста
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 53, 53, 53), // Белый текст
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemWidget(GameItem item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
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
