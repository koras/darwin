import 'package:flutter/material.dart';

import '../models/game_item.dart';
import 'game_grid.dart';
import 'game_item_widget.dart';
import 'dragging_item_widget.dart';

class GameField extends StatelessWidget {
  final List<GameItem> gameItems;
  final GameItem? draggedItem;
  final double cellSize;
  final Function(DragStartDetails) onDragStart;
  final Function(DragUpdateDetails) onDragUpdate;
  final Function(DragEndDetails) onDragEnd;

  const GameField({
    required this.gameItems,
    required this.draggedItem,
    required this.cellSize,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onPanUpdate: onDragUpdate,
        onPanEnd: onDragEnd,
        onPanStart: onDragStart,
        child: Container(
          color: Colors.grey[200],
          child: Stack(
            children: [
              GameGrid(rows: 5, columns: 5),
              ...gameItems.map(
                (item) => GameItemWidget(item: item, cellSize: cellSize),
              ),
              if (draggedItem != null)
                DraggingItemWidget(item: draggedItem!, cellSize: cellSize),
            ],
          ),
        ),
      ),
    );
  }
}
