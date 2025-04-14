import 'package:flutter/material.dart';
import '../models/image_item.dart';
import '../logic/game_field_manager.dart';

class ToolboxItemWidget extends StatelessWidget {
  final ImageItem imgItem;
  final double size;
  final FieldManager fieldManager;
  final BuildContext context;
  final void Function() onItemAdded;

  const ToolboxItemWidget({
    Key? key,
    required this.imgItem,
    required this.size,
    required this.fieldManager,
    required this.context,
    required this.onItemAdded,
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
    final double circleSize = size * 0.7;
    final double borderWidth = 2.0;
    final borderColor = _generateCalmColor(imgItem.slug);

    return GestureDetector(
      onTap: () {
        fieldManager.tryAddItem(
          context: this.context,
          item: imgItem,
          onAdd: (_) => onItemAdded(),
        );
      },
      child: SizedBox(
        width: size,
        height: size,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: borderWidth),
              ),
              child: ClipOval(
                child: Image.asset(imgItem.assetPath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: size,
              child: Text(
                imgItem.slug,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
