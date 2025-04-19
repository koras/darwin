import '../models/game_item.dart';
import '../models/image_item.dart';
import '../widgets/game_snackbar.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class FieldManager {
  final List<GameItem> Function() getItems;
  final void Function(GameItem) addItem;
  final int maxItems;
  final int maxSameType;
  final int rows;
  final int columns;
  final Random _random = Random();

  FieldManager({
    required this.getItems,
    required this.addItem,
    required this.maxItems,
    required this.maxSameType,
    required this.rows,
    required this.columns,
  });

  void tryAddItem({
    required BuildContext context,
    required ImageItem item,
    required void Function(GameItem) onAdd,
  }) {
    final items = getItems();

    if (items.length >= maxItems) {
      GameSnackbar.show(context, 'Максимум $maxItems элементов на поле');
      return;
    }

    final sameTypeCount = items.where((i) => i.id == item.id).length;
    if (sameTypeCount >= maxSameType) {
      GameSnackbar.show(context, 'Максимум $maxSameType элементов одного типа');
      return;
    }
    // Собираем список всех свободных ячеек
    final List<Point<int>> freeCells = [];
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < columns; x++) {
        final isCellEmpty = !items.any((i) => i.gridX == x && i.gridY == y);
        if (isCellEmpty) {
          freeCells.add(Point(x, y));
        }
      }
    }
    if (freeCells.isEmpty) {
      GameSnackbar.show(context, 'Нет свободных ячеек');
      return;
    }
    // Выбираем случайную свободную ячейку
    final randomCell = freeCells[_random.nextInt(freeCells.length)];
    final newItem = GameItem(
      id: item.id,
      slug: item.slug,
      assetPath: item.assetPath,
      gridX: randomCell.x,
      gridY: randomCell.y,
    );

    addItem(newItem);
    onAdd(newItem);
  }
}
