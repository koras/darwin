import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../models/game_item.dart';
import '../models/image_item.dart';
import '../logic/game_field_manager.dart';
import '../logic/merge_handler.dart';
import '../widgets/game_field.dart';
import '../widgets/toolbox_panel.dart';

class MergeGame extends StatefulWidget {
  @override
  _MergeGameState createState() => _MergeGameState();
}

class _MergeGameState extends State<MergeGame> {
  double _toolboxHeightPercentage = 0.3;
  late FieldManager _fieldManager;

  final List<GameItem> _gameItems = [];
  final int maxItems = 20;
  final int maxSameType = 3;

  final int gridColumns = 5;
  final int gridRows = 5;
  late double cellSize;
  GameItem? _draggedItem;
  Offset? _dragStartPosition;

  final List<ImageItem> _toolboxImages = allImages.take(5).toList();
  late List<ImageItem> gameImages;

  final Map<String, Offset> positions = {};
  final Map<String, bool> isVisible = {};
  String? resultImageId;
  late MergeHandler _mergeHandler;

  @override
  void initState() {
    super.initState();

    _fieldManager = FieldManager(
      getItems: () => _gameItems,
      addItem: (GameItem newItem) {
        setState(() {
          _gameItems.add(newItem);
        });
      },
      maxItems: maxItems,
      maxSameType: maxSameType,
      rows: gridRows,
      columns: gridColumns,
    );

    _mergeHandler = MergeHandler(
      context: context,
      gameItems: _gameItems,
      onMergeComplete: (mergedItem) {
        setState(() {});
      },
    );

    _toolboxImages.addAll(allImages.take(5));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final toolboxHeight = screenSize.height * _toolboxHeightPercentage;
    cellSize = screenSize.width / gridColumns;

    return Scaffold(
      body: Column(
        children: [
          GameField(
            gameItems: _gameItems,
            draggedItem: _draggedItem,
            cellSize: cellSize,
            onDragStart: _handleGlobalDragStart,
            onDragUpdate: _handleDragUpdate,
            onDragEnd: _handleDragEnd,
          ),
          ToolboxPanel(
            height: toolboxHeight,
            toolboxImages: _toolboxImages,
            fieldManager: _fieldManager,
            onHeightChanged: (newHeightPercentage) {
              setState(() {
                _toolboxHeightPercentage = newHeightPercentage;
              });
            },
            onItemAdded: () {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  void _handleGlobalDragStart(DragStartDetails details) {
    final touchPosition = details.globalPosition;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(touchPosition);

    final touchedX = (localPosition.dx / cellSize).floor();
    final touchedY = (localPosition.dy / cellSize).floor();

    final touchedItem = _gameItems.firstWhereOrNull(
      (item) => item.gridX == touchedX && item.gridY == touchedY,
    );

    if (touchedItem != null) {
      _startDragging(touchedItem, touchPosition);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_draggedItem != null) {
      final item = _draggedItem!;
      final newX =
          ((item.gridX * cellSize + item.dragOffset.dx) / cellSize).round();
      final newY =
          ((item.gridY * cellSize + item.dragOffset.dy) / cellSize).round();

      setState(() {
        item.dragOffset = Offset.zero;
        if (_isCellEmpty(newX, newY)) {
          item.gridX = newX;
          item.gridY = newY;
        }
        _gameItems.add(item);
        _draggedItem = null;
        _checkForMerge(item);
      });
    }
  }

  void _startDragging(GameItem item, Offset startPosition) {
    print('_startDragging перетаскиваем элемент ${item.slug}  ');

    setState(() {
      _draggedItem = item;
      _dragStartPosition = startPosition;
      _gameItems.remove(item);
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_draggedItem != null) {
      setState(() {
        _draggedItem!.dragOffset = details.globalPosition - _dragStartPosition!;
      });
    }
  }

  void _checkForMerge(GameItem movedItem) {
    for (final item in _gameItems) {
      if (item != movedItem &&
          (item.gridX - movedItem.gridX).abs() <= 1 &&
          (item.gridY - movedItem.gridY).abs() <= 1) {
        _mergeHandler.tryMergeItems(movedItem, item);
        return;
      }
    }
  }

  bool _isCellEmpty(int x, int y) {
    if (x < 0 || x >= gridColumns || y < 0 || y >= gridRows) return false;
    return !_gameItems.any(
      (item) => item.gridX == x && item.gridY == y && !item.isDragging,
    );
  }
}
