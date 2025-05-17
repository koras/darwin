import 'package:flutter/material.dart'; // Для использования firstWhereOrNull

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darwin/models/game_item.dart';
import 'package:darwin/logic/merge_handler.dart';
import 'package:darwin/logic/merge_logic.dart';
import 'package:darwin/bloc/level_bloc.dart';

class DragAndMergeManager {
  final BuildContext context;
  final int gridColumns;
  final int gridRows;
  final double cellSize;
  final double toolboxHeight;
  final MergeHandler mergeHandler;

  GameItem? _draggedItem;
  Offset? _dragStartPosition;

  DragAndMergeManager({
    required this.context,
    required this.gridColumns,
    required this.gridRows,
    required this.cellSize,
    required this.toolboxHeight,
    required this.mergeHandler,
  });

  GameItem? get draggedItem => _draggedItem;

  void startDragging(GameItem item, Offset startPosition) {
    context.read<LevelBloc>().add(RemoveGameItemsEvent(items: [item]));
    _draggedItem = item;
    _dragStartPosition = startPosition;
  }

  void handleDragUpdate(DragUpdateDetails details) {
    if (_draggedItem != null) {
      _draggedItem = _draggedItem!.copyWith(
        dragOffset: details.globalPosition - _dragStartPosition!,
      );
    }
  }

  Future<void> handleDragEnd(DragEndDetails details) async {
    if (_draggedItem == null || _dragStartPosition == null) return;

    final item = _draggedItem!;
    final newX =
        ((item.gridX * cellSize + item.dragOffset.dx) / cellSize).round();
    final newY =
        ((item.gridY * cellSize + item.dragOffset.dy) / cellSize).round();

    if (newX != item.gridX || newY != item.gridY) {
      final mergeSuccess = await _checkForMerge(item, newX, newY);

      if (mergeSuccess) {
        _clearDraggedItem();
        return;
      }

      if (_isCellEmpty(newX, newY)) {
        _moveItemToNewPosition(item, newX, newY);
      } else {
        _returnItemToOriginalPosition(item);
      }
    } else {
      _returnItemToOriginalPosition(item);
    }

    _clearDraggedItem();
  }

  bool _isCellEmpty(int x, int y) {
    final gameItems = context.read<LevelBloc>().state.gameItems ?? [];
    if (x < 0 || x >= gridColumns || y < 0 || y >= gridRows) return false;
    return !gameItems.any((item) => item.gridX == x && item.gridY == y);
  }

  Future<bool> _checkForMerge(GameItem movedItem, int newX, int newY) async {
    // Находим все элементы в текущей ячейке перемещенного элемента

    final state = context.read<LevelBloc>().state;
    final items = state.gameItems ?? [];

    final itemsInCell =
        items.where((item) {
          final isSameCell = newX == item.gridX && newY == item.gridY;
          final isNotMovedItem = item != movedItem;
          final shouldInclude = isNotMovedItem && isSameCell;
          return shouldInclude;
        }).toList();
    // debugPrint('Проверяем слияние с каждым элементом в ячейке');
    // Проверяем слияние с каждым элементом в ячейке
    for (final item in itemsInCell) {
      if (getMergeResult(movedItem.id, item.id) != null) {
        final result = await mergeHandler.tryMergeItems(movedItem, item);
        if (result) {
          context.read<LevelBloc>().add(UseHintEvent());
        }
        return result;
        //   return; // Сливаем только с одним элементом за раз
      }
    }
    return false;
  }

  Future<bool> _checkForMerge1111(
    GameItem movedItem,
    int newX,
    int newY,
  ) async {
    final items = context.read<LevelBloc>().state.gameItems ?? [];
    final itemsInCell =
        items.where((item) {
          return newX == item.gridX && newY == item.gridY && item != movedItem;
        }).toList();

    for (final item in itemsInCell) {
      if (getMergeResult(movedItem.id, item.id) != null) {
        final result = await mergeHandler.tryMergeItems(movedItem, item);
        if (result) {
          context.read<LevelBloc>().add(UseHintEvent());
        }
        return result;
      }
    }
    return false;
  }

  void _moveItemToNewPosition(GameItem item, int newX, int newY) {
    context.read<LevelBloc>().add(
      AddGameItemsEvent(
        items: [
          item.copyWith(gridX: newX, gridY: newY, dragOffset: Offset.zero),
        ],
      ),
    );
  }

  void _returnItemToOriginalPosition(GameItem item) {
    context.read<LevelBloc>().add(
      AddGameItemsEvent(
        items: [
          item.copyWith(dragOffset: Offset.zero, tempOffset: item.dragOffset),
        ],
      ),
    );
  }

  void _clearDraggedItem() {
    _draggedItem = null;
    _dragStartPosition = null;
  }
}
