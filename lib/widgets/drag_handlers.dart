import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'game_state.dart';
import '../models/game_item.dart';

class DragHandlers {
  final GameState _gameState;

  DragHandlers(this._gameState);

  void handleGlobalDragStart(DragStartDetails details) {
    final touchPosition = details.globalPosition;
    final RenderBox renderBox =
        _gameState.context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(touchPosition);

    final touchedX = (localPosition.dx / _gameState.cellSize).floor();
    final touchedY = (localPosition.dy / _gameState.cellSize).floor();

    final touchedItem = _gameState.gameItems.firstWhereOrNull(
      (item) => item.gridX == touchedX && item.gridY == touchedY,
    );

    if (touchedItem != null) {
      _startDragging(touchedItem, touchPosition);
    }
  }

  void handleDragEnd(DragEndDetails details) {
    if (_gameState.draggedItem != null) {
      final item = _gameState.draggedItem!;
      final newX =
          ((item.gridX * _gameState.cellSize + item.dragOffset.dx) /
                  _gameState.cellSize)
              .round();
      final newY =
          ((item.gridY * _gameState.cellSize + item.dragOffset.dy) /
                  _gameState.cellSize)
              .round();

      // Сбрасываем смещение
      item.dragOffset = Offset.zero;
      // Если клетка свободна - перемещаем элемент
      if (_gameState.isCellEmpty(newX, newY)) {
        item.gridX = newX;
        item.gridY = newY;
      }
      // Возвращаем элемент на поле (в новую или старую позицию)
      _gameState.gameItems.add(item);
      _gameState.draggedItem = null;

      // Проверяем возможные слияния
      _checkForMerge(item);
    }
  }

  void handleDragUpdate(DragUpdateDetails details) {
    if (_gameState.draggedItem != null) {
      _gameState.draggedItem!.dragOffset =
          details.globalPosition - _gameState.dragStartPosition!;
    }
  }

  void handleToolboxResize(DragUpdateDetails details) {
    _gameState.toolboxHeightPercentage -=
        details.delta.dy / MediaQuery.of(_gameState.context).size.height;
    _gameState.toolboxHeightPercentage = _gameState.toolboxHeightPercentage
        .clamp(0.15, 0.4);
  }

  void _startDragging(GameItem item, Offset startPosition) {
    _gameState.draggedItem = item;
    _gameState.dragStartPosition = startPosition;
    _gameState.gameItems.remove(item);
  }

  void _checkForMerge(GameItem movedItem) {
    for (final item in _gameState.gameItems) {
      if (item != movedItem &&
          (item.gridX - movedItem.gridX).abs() <= 1 &&
          (item.gridY - movedItem.gridY).abs() <= 1) {
        _gameState.mergeHandler.tryMergeItems(movedItem, item);
        return;
      }
    }
  }
}
