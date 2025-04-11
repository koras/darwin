import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../logic/merge_logic.dart';
import '../models/game_item.dart';
import '../models/image_item.dart';
import '../models/merge_rule.dart';
import '../widgets/game_grid.dart';
import '../utils/ui_helpers.dart';
import '../logic/game_field_manager.dart';

class MergeGame extends StatefulWidget {
  @override
  _MergeGameState createState() => _MergeGameState();
}

class _MergeGameState extends State<MergeGame> {
  double _toolboxHeightPercentage = 0.3; // Начальная высота панели (30% экрана)

  // Геттер для вычисления высоты игрового поля
  double get _gameAreaHeight =>
      MediaQuery.of(context).size.height * _gameAreaPercentage;

  // Геттер для высоты панели инструментов
  // double get _toolboxHeight =>
  //     MediaQuery.of(context).size.height * (1 - _gameAreaPercentage);

  final List<GameItem> _gameItems = [];

  final int maxItems = 20;
  final int maxSameType = 3;

  // Параметры сетки
  final int gridColumns = 5;
  final int gridRows = 5;
  late double cellSize;
  GameItem? _draggedItem;
  Offset? _dragStartPosition;
  late FieldManager _fieldManager;

  double _gameAreaPercentage = 0.7; // Начальная высота (70%)

  final List<ImageItem> _toolboxImages = allImages.take(5).toList();

  // Выбранные картинки для игры (например, 3 из всех)
  late List<ImageItem> gameImages;

  // Позиции и видимость
  final Map<String, Offset> positions = {};
  final Map<String, bool> isVisible = {};
  String? resultImageId;

  @override
  void initState() {
    super.initState();
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
                    ..._gameItems.map((item) => _buildGameItem(item)),

                    // Перетаскиваемый элемент (если есть)
                    if (_draggedItem != null) _buildDraggingItem(),
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
                          child: _buildToolboxItem(
                            _toolboxImages[index],
                            itemSize,
                          ),
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

  Widget _buildDraggingItem() {
    print('смена позиции');
    return Positioned(
      left:
          _draggedItem!.gridX * cellSize +
          cellSize * 0.1 +
          _draggedItem!.dragOffset.dx,
      top:
          _draggedItem!.gridY * cellSize +
          cellSize * 0.1 +
          _draggedItem!.dragOffset.dy,
      child: Container(
        width: cellSize * 0.8,
        height: cellSize * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Image.asset(_draggedItem!.assetPath, fit: BoxFit.contain),
      ),
    );
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

  Widget _buildGameItem(GameItem item) {
    //  print(' элемент на поле  ${item.slug}');

    return Positioned(
      left: item.gridX * cellSize + cellSize * 0.1,
      top: item.gridY * cellSize + cellSize * 0.1,
      child: GestureDetector(
        child: Container(
          width: cellSize * 0.8,
          height: cellSize * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Image.asset(item.assetPath, fit: BoxFit.contain),
        ),
      ),
    );
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
        _tryMergeItems(movedItem, item);
        return;
      }
    }
  }

  void _tryMergeItems(GameItem item1, GameItem item2) {
    final resultId = getMergeResult(item1.id, item2.id);

    if (resultId != null) {
      final resultItem = allImages.firstWhere((img) => img.id == resultId);
      final mergeX = item1.gridX;
      final mergeY = item1.gridY;

      setState(() {
        _gameItems.remove(item1);
        _gameItems.remove(item2);
        _gameItems.add(
          GameItem(
            id: resultItem.id,
            slug: resultItem.slug,
            assetPath: resultItem.assetPath,
            gridX: mergeX,
            gridY: mergeY,
          ),
        );
      });

      showGameMessage(context, 'Получено: ${resultItem.slug}');
    }
  }

  void _addToGameFieldOld(ImageItem item) {
    print("Добавляем элемент ${item.id}");

    // Проверка ограничений
    if (_gameItems.length >= maxItems) {
      showGameMessage(context, 'Максимум $maxItems элементов на поле');
      return;
    }

    final sameTypeCount = _gameItems.where((i) => i.id == item.id).length;
    if (sameTypeCount >= maxSameType) {
      showGameMessage(context, 'Максимум $maxSameType элементов одного типа');
      return;
    }

    // Находим первую свободную ячейку
    for (int y = 0; y < gridRows; y++) {
      for (int x = 0; x < gridColumns; x++) {
        if (_isCellEmpty(x, y)) {
          setState(() {
            _gameItems.add(
              GameItem(
                id: item.id,
                slug: item.slug,
                assetPath: item.assetPath,
                gridX: x,
                gridY: y,
              ),
            );
          });
          return;
        }
      }
    }

    showGameMessage(context, 'Нет свободных ячеек');
  }

  bool _isCellEmpty(int x, int y) {
    if (x < 0 || x >= gridColumns || y < 0 || y >= gridRows) return false;
    return !_gameItems.any(
      (item) => item.gridX == x && item.gridY == y && !item.isDragging,
    );
  }

  // Полоса для растягивания
  Widget _buildToolboxItem(ImageItem imgItem, double size) {
    return GestureDetector(
      // print("Добавлен ${imgItem.id}")
      onTap:
          () => {
            //   _addToGameField(imgItem)
            _fieldManager.tryAddItem(
              context: context,
              item: imgItem,
              onAdd: (newItem) {
                setState(() {
                  _gameItems.add(newItem);
                });
              },
            ),
          }, // Замените на вашу логику
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 1),
          ],
        ), // Добавлена закрывающая скобка

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Картинка (занимает большую часть пространства)
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  imgItem.assetPath,
                  fit: BoxFit.contain,
                  width: size - 20,
                  height: size - 20,
                ),
              ),
            ),

            // Текстовая подпись
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                imgItem.slug, // Преобразуем item_1 в "item 1"
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkCollisions() {
    final visibleImages =
        gameImages.where((img) => isVisible[img.id]!).toList();

    // Проверяем все пары
    for (int i = 0; i < visibleImages.length; i++) {
      for (int j = i + 1; j < visibleImages.length; j++) {
        final img1 = visibleImages[i];
        final img2 = visibleImages[j];

        final distance = (positions[img1.id]! - positions[img2.id]!).distance;

        if (distance < 100) {
          // Дистанция для слияния
          final resultId = getMergeResult(img1.id, img2.id);
          if (resultId != null) {
            setState(() {
              isVisible[img1.id] = false;
              isVisible[img2.id] = false;
              resultImageId = resultId;
            });
            return;
          }
        }
      }
    }
  }
}
