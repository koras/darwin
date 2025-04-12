import 'package:flutter/material.dart';

import '../models/game_item.dart';
import '../models/image_item.dart';
import '../logic/game_field_manager.dart';
import '../logic/merge_handler.dart';

class GameState {
  final int maxItems;
  final int maxSameType;
  final int gridColumns;
  final int gridRows;
  final BuildContext context;

  double toolboxHeightPercentage = 0.3;
  late FieldManager fieldManager;
  late MergeHandler mergeHandler;

  List<GameItem> gameItems = [];
  List<ImageItem> toolboxImages = [];

  GameItem? draggedItem;
  Offset? dragStartPosition;

  late double cellSize;
  late double itemSize;

  GameState({
    required this.maxItems,
    required this.maxSameType,
    required this.gridColumns,
    required this.gridRows,
    required this.context,
  }) {
    fieldManager = FieldManager(
      getItems: () => gameItems,
      addItem: (GameItem newItem) {
        gameItems.add(newItem);
      },
      maxItems: maxItems,
      maxSameType: maxSameType,
      rows: gridRows,
      columns: gridColumns,
    );

    mergeHandler = MergeHandler(
      context: context,
      gameItems: gameItems,
      onMergeComplete: (mergedItem) {},
    );

    toolboxImages.addAll(allImages.take(5));
  }

  double get toolboxHeight =>
      MediaQuery.of(context).size.height * toolboxHeightPercentage;

  void updateCellSize(Size screenSize) {
    cellSize = screenSize.width / gridColumns;
    itemSize = screenSize.width / 4 - 12;
  }

  bool isCellEmpty(int x, int y) {
    if (x < 0 || x >= gridColumns || y < 0 || y >= gridRows) return false;
    return !gameItems.any(
      (item) => item.gridX == x && item.gridY == y && !item.isDragging,
    );
  }
}
