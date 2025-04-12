import '../models/game_item.dart';
import '../models/image_item.dart';
import '../widgets/game_snackbar.dart';
import 'package:flutter/material.dart';

class FieldManager {
  final List<GameItem> gameItems;
  final int maxItems;
  final int maxSameType;
  final int gridColumns;
  final int gridRows;

  FieldManager({
    required this.gameItems,
    required this.maxItems,
    required this.maxSameType,
    required this.gridColumns,
    required this.gridRows,
  });

  bool isCellEmpty(List<GameItem> currentItems, int x, int y) {
    return !currentItems.any(
      (item) => item.gridX == x && item.gridY == y && !item.isDragging,
    );
  }

  bool tryAddItem({
    required BuildContext context,
    required ImageItem item,
    required void Function(GameItem) onAdd,
  }) {
    if (gameItems.length >= maxItems) {
      GameSnackbar.show(context, 'Максимум $maxItems элементов на поле');
      return false;
    }

    final sameTypeCount = gameItems.where((i) => i.id == item.id).length;
    if (sameTypeCount >= maxSameType) {
      GameSnackbar.show(context, 'Максимум $maxSameType элементов одного типа');
      return false;
    }

    for (int y = 0; y < gridRows; y++) {
      for (int x = 0; x < gridColumns; x++) {
        if (isCellEmpty(gameItems, x, y)) {
          final newItem = GameItem(
            id: item.id,
            slug: item.slug,
            assetPath: item.assetPath,
            gridX: x,
            gridY: y,
          );
          onAdd(newItem);
          return true;
        }
      }
    }

    GameSnackbar.show(context, 'Нет свободных ячеек');
    return false;
  }
}
