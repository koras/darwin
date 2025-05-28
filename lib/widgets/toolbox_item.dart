import 'package:flutter/material.dart';
import 'package:darwin/data/image_item.dart';
import 'package:darwin/models/game_item.dart';
import 'package:darwin/gen_l10n/app_localizations.dart';

import 'package:darwin/data/app_localizations_extensions.dart';
import 'package:darwin/logic/generate_calm_color.dart';
import 'dart:math';

class ToolboxItemWidget extends StatelessWidget {
  final ImageItem imgItem;
  final double size;
  // final BuildContext context;
  final Function(GameItem) onItemAdded;

  const ToolboxItemWidget({
    Key? key,
    required this.imgItem,
    required this.size,
    //   required this.context,
    required this.onItemAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double circleSize = size * 0.7;
    final double borderWidth = 2.0;
    final Random _random = Random();
    // Генерация спокойного цвета на основе строки
    final borderColor = generateCalmColor(imgItem.slug);

    String _generateUniqueKey() {
      return '${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(100000)}';
    }

    return GestureDetector(
      onTap: () {
        final gameItem = GameItem(
          id: imgItem.id,
          key: _generateUniqueKey(),
          slug: imgItem.slug,
          assetPath: imgItem.assetPath,
          gridX: 0,
          gridY: 0,
        )..dragOffset = imgItem.position;

        onItemAdded(gameItem);
        // fieldManager.tryAddItem(
        //   context: this.context,
        //   item: imgItem,
        //   onAdd: (_) => onItemAdded(),
        // );
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
                //    imgItem.slug,
                AppLocalizations.of(context)!.getString(context, imgItem.slug),
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
