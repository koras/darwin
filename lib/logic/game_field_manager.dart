import '../models/game_item.dart';
import '../models/image_item.dart';
import '../widgets/game_snackbar.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class FieldManager {
  late List<GameItem> Function() getItems;
  //  final void Function(GameItem) addItem;
  final int maxItems;
  final int maxSameType;
  final int rows;
  final int columns;
  final Random _random = Random();

  FieldManager({
    //  required this.addItem,
    required this.maxItems,
    required this.maxSameType,
    required this.rows,
    required this.columns,
    required this.getItems,
  });

  String _generateUniqueKey() {
    return '${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(100000)}';
  }

  GameItem? tryAddItem({
    required BuildContext context,
    required GameItem item,
    //required void Function(GameItem) onAdd,
  }) {
    final items = getItems();

    if (items.length >= maxItems) {
      GameSnackbar.show(context, 'Максимум $maxItems элементов на поле');
      return null;
    }

    final sameTypeCount = items.where((i) => i.id == item.id).length;

    for (final item in items) {
      print('ID: ${item.gridX}');
      print('ID: ${item.gridY}');
      print('ID: ${item.assetPath}');
    }
    if (sameTypeCount >= maxSameType) {
      GameSnackbar.show(context, 'Максимум $maxSameType элементов одного типа');
      return null;
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
      return null;
    }
    // Выбираем случайную свободную ячейку
    final randomCell = freeCells[_random.nextInt(freeCells.length)];
    final newItem = GameItem(
      id: item.id,
      key: _generateUniqueKey(),
      slug: item.slug,
      assetPath: item.assetPath,
      gridX: randomCell.x,
      gridY: randomCell.y,
    );
    print('ключи тест ${newItem.key}');
    // addItem(newItem);
    // onAdd(newItem);

    return newItem;
  }
}
