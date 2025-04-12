import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../models/game_item.dart';
import '../models/image_item.dart';
import '../widgets/toolbox_item.dart';
import '../widgets/game_grid.dart';
import '../logic/game_field_manager.dart';
import '../logic/merge_handler.dart';
import '../widgets/game_item_widget.dart';
import '../widgets/dragging_item_widget.dart';

class MergeGame extends StatefulWidget {
  @override
  _MergeGameState createState() => _MergeGameState();
}

class _MergeGameState extends State<MergeGame> {
  double _toolboxHeightPercentage = 0.3; // Начальная высота панели (30% экрана)
  late FieldManager _fieldManager;

  final List<GameItem> _gameItems = [];
  final int maxItems = 20;
  final int maxSameType = 3;

  // Параметры сетки
  final int gridColumns = 5;
  final int gridRows = 5;
  late double cellSize;
  GameItem? _draggedItem;
  Offset? _dragStartPosition;

  final List<ImageItem> _toolboxImages = allImages.take(5).toList();
  late List<ImageItem> gameImages;

  // Позиции и видимость
  final Map<String, Offset> positions = {};
  final Map<String, bool> isVisible = {};
  String? resultImageId;
  // В классе _MergeGameState добавляем поле
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
        setState(() {}); // Обновляем UI после слияния
      },
    );

    _toolboxImages.addAll(allImages.take(5));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // final screenHeight = MediaQuery.of(context).size.height;
    final toolboxHeight = screenSize.height * _toolboxHeightPercentage;

    cellSize = screenSize.width / gridColumns;

    final itemSize =
        MediaQuery.of(context).size.width / 4 -
        12; // 4 элемента в ряд с отступами

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: _handleDragUpdate,
              onPanEnd: _handleDragEnd,
              onPanStart: _handleGlobalDragStart,
              child: Container(
                color: Colors.grey[200],
                child: Stack(
                  children: [
                    // Сетка
                    // _buildGrid(),
                    GameGrid(rows: 5, columns: 5),
                    // Элементы на поле
                    ..._gameItems.map(
                      (item) => GameItemWidget(item: item, cellSize: cellSize),
                    ),
                    //                    ..._gameItems.map((item) => _buildGameItem(item)),
                    // Перетаскиваемый элемент (если есть)
                    if (_draggedItem != null)
                      DraggingItemWidget(
                        item: _draggedItem!,
                        cellSize: cellSize,
                      ),
                    //_buildDraggingItem(),
                  ],
                ),
              ),
            ),
          ),

          // Панель инструментов (статичные картинки)
          SizedBox(
            height: toolboxHeight,
            child: Column(
              children: [
                // Полоса для растягивания
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      _toolboxHeightPercentage -=
                          details.delta.dy / screenSize.height;
                      _toolboxHeightPercentage = _toolboxHeightPercentage.clamp(
                        0.15,
                        0.4,
                      );
                    });
                  },
                  child: Container(
                    height: 24,
                    color: Colors.blueGrey[300],
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 4,
                        color: Colors.blueGrey[500],
                      ),
                    ),
                  ),
                ),

                // Скроллируемая область с фиксированными элементами
                Expanded(
                  child: Container(
                    color: Colors.blueGrey[100],
                    child: GridView.builder(
                      padding: EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // 4 элемента в ряд
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1, // Квадратные элементы
                      ),
                      itemCount: _toolboxImages.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: itemSize,
                          height: itemSize,

                          // Полоса для растягивания
                          child: ToolboxItemWidget(
                            imgItem: _toolboxImages[index],
                            size: itemSize,
                            fieldManager: _fieldManager,
                            context: context,
                            onItemAdded: () {
                              setState(() {}); // обновляем _gameItems
                            },
                          ),

                          // child: _buildToolboxItem(
                          //   _toolboxImages[index],
                          //   itemSize,
                          // ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
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
        // Сбрасываем смещение
        item.dragOffset = Offset.zero;
        // Если клетка свободна - перемещаем элемент
        if (_isCellEmpty(newX, newY)) {
          item.gridX = newX;
          item.gridY = newY;
        }
        // Возвращаем элемент на поле (в новую или старую позицию)
        _gameItems.add(item);
        _draggedItem = null;

        // Проверяем возможные слияния
        _checkForMerge(item);
      });
    }
  }

  void _startDragging(GameItem item, Offset startPosition) {
    print('_startDragging перетаскиваем элемент ${item.slug}  ');

    setState(() {
      _draggedItem = item;
      _dragStartPosition = startPosition;
      // Сразу удаляем элемент из исходного положения
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

  // Проверяем возможные слияния для перемещенного элемента
  void _checkForMerge(GameItem movedItem) {
    for (final item in _gameItems) {
      if (item != movedItem &&
          (item.gridX - movedItem.gridX).abs() <= 1 &&
          (item.gridY - movedItem.gridY).abs() <= 1) {
        //  _tryMergeItems(movedItem, item);
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
