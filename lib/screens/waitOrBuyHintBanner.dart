import 'package:flutter/material.dart';
import 'package:darwin/models/game_item.dart';
import 'package:darwin/models/image_item.dart';

class WaitOrBuyHintBanner extends StatelessWidget {
  final Duration remainingTime;
  final VoidCallback onClose;
  final VoidCallback onBuy5Hints;
  final VoidCallback onBuy10Hints;
  final VoidCallback onBuy20Hints;

  const WaitOrBuyHintBanner({
    Key? key,

    required this.remainingTime,
    required this.onClose,
    required this.onBuy5Hints,
    required this.onBuy10Hints,
    required this.onBuy20Hints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Получаем данные элементов

    // Форматируем оставшееся время
    final minutes = remainingTime.inMinutes;
    final seconds = remainingTime.inSeconds % 60;
    final timeText =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

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
                '5 подсказок',
                '100 ₽',
                onBuy5Hints,
                Colors.blueAccent,
              ),
              const SizedBox(height: 10),

              _buildPurchaseOption(
                context,
                '10 подсказок',
                '200 ₽',
                onBuy10Hints,
                Colors.green,
              ),
              const SizedBox(height: 10),

              _buildPurchaseOption(
                context,
                '20 подсказок',
                '500 ₽',
                onBuy20Hints,
                Colors.purple,
              ),
              const SizedBox(height: 20),

              // Кнопка закрытия
              TextButton(
                onPressed: onClose,
                child: const Text(
                  'Закрыть',
                  style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                ),
              ),
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Text(
            price,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
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
