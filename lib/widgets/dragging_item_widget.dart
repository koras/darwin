import 'package:flutter/material.dart';
import 'package:darwin/models/game_item.dart';

class DraggingItemWidget extends StatelessWidget {
  final GameItem item;
  final double cellSize;
  final double
  scaleFactor; // Добавляем коэффициент масштабирования при перетаскивании

  const DraggingItemWidget({
    Key? key,
    required this.item,
    required this.cellSize,
    this.scaleFactor = 1.1, // Элемент немного увеличивается при перетаскивании
  }) : super(key: key);

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
    final double baseSize = cellSize * 0.7;
    final double scaledSize = baseSize * scaleFactor;
    final double borderWidth = 2.0 * scaleFactor; // Бордюр тоже масштабируется
    final borderColor = _generateCalmColor(item.slug);

    return Positioned(
      left:
          item.gridX * cellSize +
          (cellSize - baseSize) / 2 +
          item.dragOffset.dx,
      top:
          item.gridY * cellSize +
          (cellSize - baseSize) / 2 +
          item.dragOffset.dy,
      child: Transform.scale(
        scale: scaleFactor,
        child: Container(
          width: baseSize,
          height: baseSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8 * scaleFactor,
                spreadRadius: 1 * scaleFactor,
                offset: Offset(0, 3 * scaleFactor),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: ClipOval(
              child: Image.asset(item.assetPath, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}
