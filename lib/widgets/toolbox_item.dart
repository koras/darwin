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
      0.3, // Saturation (30%)
      0.9, // Lightness (80%)
    ).toColor();
  }

  // Создание более темного цвета для бордюра
  Color _getDarkerBorderColor(Color baseColor) {
    return HSLColor.fromColor(baseColor)
        .withSaturation(0.4) // Чуть более насыщенный
        .withLightness(0.8) // Делаем на 10% темнее
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    final double circleSize = size * 0.7;
    final Color circleColor = _generateCalmColor(imgItem.slug);
    final Color borderColor = _getDarkerBorderColor(circleColor);

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
            // Круг с иконкой и бордюром
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                  width: 2.0, // Толщина бордюра
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(circleSize * 0.2),
                child: Image.asset(imgItem.assetPath, fit: BoxFit.contain),
              ),
            ),
            SizedBox(height: 8),
            // Название предмета
            SizedBox(
              width: size,
              child: Text(
                imgItem.slug,
                style: TextStyle(
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
