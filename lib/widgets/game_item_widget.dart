import 'package:flutter/material.dart';
import 'package:darwin/models/game_item.dart';

class GameItemWidget extends StatelessWidget {
  final GameItem item;
  final double cellSize;

  const GameItemWidget({Key? key, required this.item, required this.cellSize})
    : super(key: key);

  // Генерация спокойного цвета на основе строки
  Color _generateCalmColor(String input) {
    final hash = input.hashCode;
    return HSLColor.fromAHSL(
      1.0,
      (hash % 360).toDouble(), // Hue (0-360)
      0.4, // Saturation (умеренная для спокойных цветов)
      0.7, // Lightness (не слишком темный и не слишком светлый)
    ).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final double circleSize = cellSize * 0.7;
    final double borderWidth = 2.0;
    final borderColor = _generateCalmColor(item.slug);

    return Positioned(
      left:
          item.gridX * cellSize +
          cellSize * 0.15, // Центрирование с учетом бордюра
      top: item.gridY * cellSize + cellSize * 0.15,
      child: GestureDetector(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: borderWidth),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
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
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              constraints: BoxConstraints(maxWidth: cellSize),
              child: Text(
                item.slug,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
