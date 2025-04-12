import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // Для использования firstWhereOrNull

import '../models/game_item.dart';
import '../models/image_item.dart';
import '../logic/game_field_manager.dart';
import '../logic/merge_handler.dart';
import '../widgets/game_field.dart';
import '../widgets/toolbox_panel.dart';
import '../widgets/game_panel.dart';

// Основной виджет игры, объединяющий игровое поле и панель инструментов
class MergeGame extends StatefulWidget {
  @override
  _MergeGameState createState() => _MergeGameState();
}

class _MergeGameState extends State<MergeGame> {
  // Высота панели инструментов (30% от экрана по умолчанию)
  double _toolboxHeightPercentage = 0.3;
  late FieldManager _fieldManager; // Менеджер игрового поля

  // Список игровых элементов на поле
  final List<GameItem> _gameItems = [];
  final int maxItems = 20; // Максимальное количество элементов на поле
  final int maxSameType = 3; // Максимальное количество элементов одного типа

  // Размеры игровой сетки
  final int gridColumns = 7;
  final int gridRows = 7;
  late double cellSize; // Размер одной ячейки сетки

  GameItem? _draggedItem; // Элемент, который сейчас перетаскивается
  Offset? _dragStartPosition; // Начальная позиция перетаскивания

  // Изображения для панели инструментов (первые 5 из всех доступных)
  final List<ImageItem> _toolboxImages = allImages.take(5).toList();
  late List<ImageItem> gameImages;

  // Позиции элементов и их видимость
  final Map<String, Offset> positions = {};
  final Map<String, bool> isVisible = {};
  String? resultImageId; // ID результирующего изображения после слияния

  late MergeHandler _mergeHandler; // Обработчик слияния элементов

  @override
  void initState() {
    super.initState();

    // Инициализация менеджера игрового поля
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

    // Инициализация обработчика слияния
    _mergeHandler = MergeHandler(
      context: context,
      gameItems: _gameItems,
      onMergeComplete: (mergedItem) {
        setState(() {}); // Обновляем UI после слияния
      },
    );

    // Добавляем начальные изображения в панель инструментов
    _toolboxImages.addAll(allImages.take(5));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final toolboxHeight = screenSize.height * _toolboxHeightPercentage;

    cellSize =
        (screenSize.width - 40) / gridColumns; // Рассчитываем размер ячейки
    print("размер ячейки ${screenSize.width}  ${cellSize}  ${gridColumns}");
    return Scaffold(
      body: Stack(
        children: [
          // Панель инструментов (верхняя часть экрана)

          // Игровое поле (верхняя часть экрана)
          GameField(
            gameItems: _gameItems,
            draggedItem: _draggedItem,
            cellSize: cellSize,
            onDragStart: _handleGlobalDragStart,
            onDragUpdate: _handleDragUpdate,
            onDragEnd: _handleDragEnd,
          ),

          // Панель инструментов (нижняя часть экрана)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: toolboxHeight,
            child: ToolboxPanel(
              toolboxImages: _toolboxImages,
              fieldManager: _fieldManager,
              onHeightChanged: (newHeightPercentage) {
                setState(() {
                  _toolboxHeightPercentage = newHeightPercentage;
                });
              },
              onItemAdded: () {
                setState(() {}); // Обновляем UI после добавления элемента
              },
            ),
          ),
        ],
      ),
    );
  }

  // Обработчик начала перетаскивания элемента
  void _handleGlobalDragStart(DragStartDetails details) {
    final touchPosition = details.globalPosition;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(touchPosition);

    // Определяем координаты касания в терминах сетки
    final touchedX = (localPosition.dx / cellSize).floor();
    final touchedY = (localPosition.dy / cellSize).floor();

    // Находим элемент по координатам
    final touchedItem = _gameItems.firstWhereOrNull(
      (item) => item.gridX == touchedX && item.gridY == touchedY,
    );

    if (touchedItem != null) {
      _startDragging(touchedItem, touchPosition); // Начинаем перетаскивание
    }
  }

  // Обработчик завершения перетаскивания
  void _handleDragEnd(DragEndDetails details) {
    if (_draggedItem != null) {
      final item = _draggedItem!;
      // Рассчитываем новые координаты в сетке
      final newX =
          ((item.gridX * cellSize + item.dragOffset.dx) / cellSize).round();
      final newY =
          ((item.gridY * cellSize + item.dragOffset.dy) / cellSize).round();

      setState(() {
        item.dragOffset = Offset.zero; // Сбрасываем смещение
        if (_isCellEmpty(newX, newY)) {
          // Если ячейка свободна - перемещаем элемент
          item.gridX = newX;
          item.gridY = newY;
        }
        _gameItems.add(item); // Возвращаем элемент на поле
        _draggedItem = null;
        _checkForMerge(item); // Проверяем возможность слияния
      });
    }
  }

  // Начало перетаскивания элемента
  void _startDragging(GameItem item, Offset startPosition) {
    setState(() {
      _draggedItem = item; // Запоминаем перетаскиваемый элемент
      _dragStartPosition = startPosition; // Запоминаем начальную позицию
      _gameItems.remove(item); // Временно удаляем элемент из списка
    });
  }

  // Обновление позиции при перетаскивании
  void _handleDragUpdate(DragUpdateDetails details) {
    if (_draggedItem != null) {
      setState(() {
        // Обновляем смещение элемента относительно начальной позиции
        _draggedItem!.dragOffset = details.globalPosition - _dragStartPosition!;
      });
    }
  }

  // Проверка возможности слияния с соседними элементами
  void _checkForMerge(GameItem movedItem) {
    for (final item in _gameItems) {
      if (item != movedItem && // Не сравниваем с самим собой
          (item.gridX - movedItem.gridX).abs() <= 1 && // Сосед по X
          (item.gridY - movedItem.gridY).abs() <= 1) {
        // Сосед по Y
        _mergeHandler.tryMergeItems(movedItem, item); // Пробуем слить
        return;
      }
    }
  }

  // Проверка, свободна ли ячейка
  bool _isCellEmpty(int x, int y) {
    // Проверка выхода за границы
    if (x < 0 || x >= gridColumns || y < 0 || y >= gridRows) return false;

    // Проверяем, есть ли в этой ячейке другие элементы (кроме перетаскиваемого)
    return !_gameItems.any(
      (item) => item.gridX == x && item.gridY == y && !item.isDragging,
    );
  }
}
