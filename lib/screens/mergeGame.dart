import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // Для использования firstWhereOrNull

import '../models/game_item.dart';
import '../models/image_item.dart';
import '../logic/game_field_manager.dart';
import '../logic/merge_handler.dart';
import '../logic/merge_logic.dart';
import '../widgets/game_field.dart';
import '../widgets/toolbox_panel.dart';
import '../widgets/game_panel.dart';
import '../widgets/bottom_app_bar_widget.dart';

import '../bloc/level_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

// Основной виджет игры, объединяющий игровое поле и панель инструментов
class MergeGame extends StatefulWidget {
  @override
  _MergeGameState createState() => _MergeGameState();
}

class _MergeGameState extends State<MergeGame> {
  // Добавляем BLoC
  late final LevelBloc _levelBloc;

  // Высота панели инструментов (30% от экрана по умолчанию)
  double _toolboxHeightPercentage = 0.20;
  late FieldManager _fieldManager; // Менеджер игрового поля

  // Список игровых элементов на поле
  final List<GameItem> _gameItems = [];
  final int maxItems = 120; // Максимальное количество элементов на поле
  final int maxSameType = 30; // Максимальное количество элементов одного типа

  // Размеры игровой сетки
  final int gridColumns = 5;
  final int gridRows = 6;
  late double cellSize; // Размер одной ячейки сетки

  GameItem? _draggedItem; // Элемент, который сейчас перетаскивается
  Offset? _dragStartPosition; // Начальная позиция перетаскивания

  // Изображения для панели инструментов (первые 5 из всех доступных)
  // final List<ImageItem> _toolboxImages = allImages.take(5).toList();

  late List<ImageItem> gameImages;

  // Позиции элементов и их видимость
  final Map<String, Offset> positions = {};
  final Map<String, bool> isVisible = {};
  String? resultImageId; // ID результирующего изображения после слияния

  late MergeHandler _mergeHandler; // Делаем полем класса

  @override
  void initState() {
    super.initState();

    _levelBloc = LevelBloc();
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

    _mergeHandler = MergeHandler(
      context: context,
      gameItems: _gameItems,
      onMergeComplete: (mergedItem) {
        if (mergedItem.id == _levelBloc.state.targetItem) {
          _levelBloc.add(LevelCompletedEvent());
        }
        setState(() {});
      },
      cellSize: 0,
      fieldTop: 0,
      levelBloc: _levelBloc, // Временное значение, будет обновлено в build()
    );
  }

  @override
  void dispose() {
    _levelBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _levelBloc,
      child: BlocBuilder<LevelBloc, LevelState>(
        builder: (context, state) {
          final screenSize = MediaQuery.of(context).size;
          final toolboxHeight = screenSize.height * _toolboxHeightPercentage;

          final levelItems =
              allImages
                  .where((image) => state.availableItems.contains(image.id))
                  .toList();

          cellSize =
              (screenSize.width - 40) /
              gridColumns; // Рассчитываем размер ячейки

          // отсутп для игрового поля
          final fieldTop = screenSize.height * 0.20;

          _mergeHandler = MergeHandler(
            context: context,
            gameItems: _gameItems,
            onMergeComplete: (mergedItem) {
              if (mergedItem.id == _levelBloc.state.targetItem) {
                _levelBloc.add(LevelCompletedEvent());
              }
              setState(() {});
            },
            cellSize: cellSize,
            fieldTop: fieldTop,
            levelBloc: context.read<LevelBloc>(),
          );

          return Scaffold(
            //    appBar: AppBar(title: Text("asdasd"), centerTitle: false),
            bottomNavigationBar: const CustomBottomAppBar(),
            body: Stack(
              children: [
                // Фоновая картинка (добавьте этот виджет первым в Stack)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            Image.asset('assets/images/background.png').image,
                        fit: BoxFit.fitWidth, // Растягиваем по ширине
                        alignment: Alignment.topCenter, // Выравниваем по верху
                        repeat:
                            ImageRepeat
                                .repeatY, // Повторяем по вертикали (клонируем вниз)
                      ),
                    ),
                  ),
                ),

                // Панель инструментов (верхняя часть экрана)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: screenSize.height * 0.20,
                  child: GamePanel(
                    name: "Задание",
                    stars: 100,
                    taskDescription: state.levelTitle,
                    time: "02:45",
                    onHintPressed: () {
                      print("Логика подсказки");

                      // Логика подсказки
                    },
                    onClearPressed: () {
                      print("Логика очистки экрана");
                      // Логика очистки экрана
                    },
                    scoreImagePath:
                        'assets/images/score_icon.png', // Ваш путь к картинке
                  ),
                ),
                // Игровое поле (верхняя часть экрана)
                Positioned(
                  top: screenSize.height * 0.15, // 20% от верха экрана
                  bottom:
                      toolboxHeight -
                      20, // Оставляем место для панели инструментов
                  left: 0,
                  right: 0,
                  child: GameField(
                    gridColumns: gridColumns,
                    gridRows: gridRows,
                    gameItems: _gameItems,
                    draggedItem: _draggedItem,
                    cellSize: cellSize,
                    mergeHandler: _mergeHandler, // Передаем handler
                    // сдвиг поля на высоту панели
                    fieldTop: fieldTop,
                    topOffset:
                        MediaQuery.of(context).size.height *
                        0.15, // Передаём сдвиг
                    onDragStart: _handleGlobalDragStart,
                    onDragUpdate: _handleDragUpdate,
                    onDragEnd: _handleDragEnd,
                  ),
                ),

                // Панель инструментов (нижняя часть экрана)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: toolboxHeight + 20,
                  child: ToolboxPanel(
                    // toolboxImages: _toolboxImages,
                    toolboxImages: levelItems,
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
        },
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

      //   print('============');
      //   print('old: item.gridX = ${item.gridX} item.gridY = ${item.gridY}');

      final newX =
          ((item.gridX * cellSize + item.dragOffset.dx) / cellSize).round();
      final newY =
          ((item.gridY * cellSize + item.dragOffset.dy) / cellSize).round();

      // print('new: newX = ${newX} newY = ${newY}');

      setState(() {
        bool merge = true;
        bool mergeItem = true;
        // Проверяем слияние только если элемент был перемещен в новую ячейку
        if (newX != item.gridX || newY != item.gridY) {
          //   print('check');
          bool mergeItem = _checkForMerge(item, newX, newY);
          if (!mergeItem) {
            _gameItems.add(item);
          }
        } else {
          _gameItems.add(item);
        }

        item.dragOffset = Offset.zero;
        if (_isCellEmpty(newX, newY)) {
          // Теперь это корректный вызов метода
          item.gridX = newX;
          item.gridY = newY;
        }
        //   if (!mergeItem) {
        //    _gameItems.add(item);
        //   }
        _draggedItem = null;
      });
    }
  }

  // Проверка возможности слияния с соседними элементами
  // Проверка возможности слияния элементов в одной ячейке
  bool _checkForMerge(GameItem movedItem, int newX, int newY) {
    // Находим все элементы в текущей ячейке перемещенного элемента
    //   print('count ${_gameItems.length}');

    final itemsInCell =
        _gameItems.where((item) {
          final isSameCell = newX == item.gridX && newY == item.gridY;
          final isNotMovedItem = item != movedItem;
          final shouldInclude = isNotMovedItem && isSameCell;
          return shouldInclude;
        }).toList();

    if (itemsInCell.isNotEmpty) {
      // print("В этой ячейке есть ${itemsInCell.length} элементов");
    }
    // Проверяем слияние с каждым элементом в ячейке
    for (final item in itemsInCell) {
      if (getMergeResult(movedItem.id, item.id) != null) {
        return _mergeHandler.tryMergeItems(movedItem, item);
        //   return; // Сливаем только с одним элементом за раз
      }
    }
    return false;
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

  bool _itemsOverlap(GameItem a, GameItem b, double threshold) {
    // Рассчитываем центры элементов
    final aCenter = Offset(a.gridX + 0.5, a.gridY + 0.5);
    final bCenter = Offset(b.gridX + 0.5, b.gridY + 0.5);

    // Расстояние между центрами
    final distance = (aCenter - bCenter).distance;
    print('distance ${distance}');
    // Элементы считаются пересекающимися, если расстояние меньше порога
    return distance < threshold;
  }

  // Проверка, свободна ли ячейка
  bool _isCellEmpty(int x, int y) {
    if (x < 0 || x >= gridColumns || y < 0 || y >= gridRows) {
      return false; // Ячейка за границами считается занятой
    }
    return !_gameItems.any((item) => item.gridX == x && item.gridY == y);
  }
}
