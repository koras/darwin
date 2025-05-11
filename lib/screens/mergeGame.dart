import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // Для использования firstWhereOrNull

import 'package:darwin/screens/hintBanner.dart';

import 'package:darwin/models/game_item.dart';
import 'package:darwin/models/image_item.dart';
import 'package:darwin/logic/game_field_manager.dart';
import 'package:darwin/logic/merge_handler.dart';
import 'package:darwin/logic/merge_logic.dart';
import 'package:darwin/widgets/game_field.dart';
import 'package:darwin/widgets/toolbox_panel.dart';
import 'package:darwin/widgets/game_panel.dart';
import 'package:darwin/widgets/bottom_app_bar_widget.dart';
import 'dart:async';

import 'package:darwin/bloc/level_bloc.dart';
import 'discoveryBanner.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'levelCompleteBanner.dart';
import 'mergeSuccessBanner.dart';

// Основной виджет игры, объединяющий игровое поле и панель инструментов
class MergeGame extends StatefulWidget {
  @override
  _MergeGameState createState() => _MergeGameState();
}

class _MergeGameState extends State<MergeGame> with TickerProviderStateMixin {
  late AnimationController _clearButtonController;
  late Animation<double> _clearButtonAnimation;

  // для плавного завершения уровня
  late AnimationController _bannerAnimationController;
  late Animation<double> _bannerOpacityAnimation;
  late Animation<double> _bannerScaleAnimation;

  bool _showHintPanel = false;
  AnimationController? _hintPanelController;
  Animation<Offset>? _hintPanelAnimation;
  Timer? _hintTimer;
  Duration _timeUntilNextHint = Duration.zero;

  // Добавляем BLoC
  late final LevelBloc _levelBloc;

  // Высота панели инструментов (30% от экрана по умолчанию)
  double _toolboxHeightPercentage = 0.20;

  // вычисленная высота верхней панели
  double _toolboxHeight = 0.0;

  //late FieldManager _fieldManager; // Менеджер игрового поля
  late final FieldManager _fieldManager;

  final List<GameItem> gameItems = [];

  final int maxItems = 120; // Максимальное количество элементов на поле
  final int maxSameType = 30; // Максимальное количество элементов одного типа

  // Размеры игровой сетки
  final int gridColumns = 5;
  final int gridRows = 5;
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

  bool _showMergeBanner = false;
  GameItem? _mergedItem;

  @override
  void initState() {
    super.initState();

    _startHintTimer();

    _fieldManager = FieldManager(
      getItems: () => context.read<LevelBloc>().state.gameItems ?? [],
      maxItems: 25, // Укажите нужные значения
      maxSameType: 25,
      rows: 5,
      columns: 5,
    );

    _levelBloc = LevelBloc();

    _mergeHandler = MergeHandler(
      context: context,
      onMergeComplete: (mergedItem) {
        if (mergedItem.id == context.read<LevelBloc>().state.targetItem) {
          context.read<LevelBloc>().add(LevelCompletedEvent());
        }
        setState(() {});
      },
      cellSize: 0,
      fieldTop: 0,
      levelBloc: context.read<LevelBloc>(),
    );

    _clearButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _clearButtonAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _clearButtonController, curve: Curves.easeInOut),
    );

    // для плавного завершения уровня
    _bannerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _bannerOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _bannerAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _bannerScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _bannerAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _hintPanelController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _hintPanelAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _hintPanelController!, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hintPanelController?.dispose();
    _clearButtonController.dispose();
    _bannerAnimationController.dispose();
    context.read<LevelBloc>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LevelBloc, LevelState>(
      builder: (context, state) {
        final screenSize = MediaQuery.of(context).size;

        _toolboxHeight = screenSize.height * _toolboxHeightPercentage;

        final levelItems =
            allImages
                .where((image) => state.availableItems.contains(image.id))
                .toList();

        cellSize =
            (screenSize.width - 40) / gridColumns; // Рассчитываем размер ячейки

        // отсутп для игрового поля
        final fieldTop = screenSize.height * 0.20;

        _mergeHandler = MergeHandler(
          context: context,
          onMergeComplete: (mergedItem) {
            debugPrint(
              'mergedItem == ${mergedItem.id} ${context.read<LevelBloc>().state.targetItem}',
            );

            if (mergedItem.id == context.read<LevelBloc>().state.targetItem) {
              debugPrint('banner');

              //    _levelBloc.add(LevelCompletedEvent());
              //_levelBloc.add(ShowLevelCompleteEvent(itemId: mergedItem.id));
              context.read<LevelBloc>().add(
                ShowLevelCompleteEvent(itemId: mergedItem.id),
              );

              setState(() {
                _mergedItem = mergedItem;
                _showMergeBanner = true;
              });

              // Сбрасываем анимацию и запускаем
              _bannerAnimationController.reset();
              _bannerAnimationController.forward(); // Запускаем анимацию
            } else {
              setState(() {});
            }
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
                      image: Image.asset('assets/images/background.png').image,
                      fit: BoxFit.fitWidth, // Растягиваем по ширине
                      alignment: Alignment.topCenter, // Выравниваем по верху
                      repeat: ImageRepeat.repeatY,
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

                    //  final state = context.read<LevelBloc>().state;
                    //   if (state.hintsState.availableHints > 0) {
                    // Показываем баннер с подсказкой
                    //     context.read<LevelBloc>().add(RequestHintEvent());
                    //  } else {
                    // Показываем панель подсказок
                    _toggleHintPanel();
                    //  }
                    // Логика подсказки
                  },
                  onClearPressed: _handleClearField, // Изменяем обработчик () {
                  // Логика очистки экрана
                  scoreImagePath:
                      'assets/images/score_icon.png', // Ваш путь к картинке,
                  clearButtonAnimation:
                      _clearButtonAnimation, // Передаем анимацию
                ),
              ),

              // Игровое поле
              Positioned(
                top: screenSize.height * 0.15, // 20% от верха экрана
                bottom:
                    _toolboxHeight -
                    20, // Оставляем место для панели инструментов
                left: 0,
                right: 0,
                child: GameField(
                  gridColumns: gridColumns,
                  gridRows: gridRows,
                  gameItems: context.read<LevelBloc>().state.gameItems ?? [],
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
                height: _toolboxHeight + 20,
                child: ToolboxPanel(
                  // toolboxImages: _toolboxImages,
                  toolboxImages: levelItems,
                  // fieldManager: _fieldManager,
                  onHeightChanged: (newHeightPercentage) {
                    setState(() {
                      _toolboxHeightPercentage = newHeightPercentage;
                    });
                  },
                  onItemAdded: (GameItem gameItem) {
                    print('Добавляем элемент через BLoC');

                    final gameItemTry = _fieldManager.tryAddItem(
                      context: context,
                      item: gameItem,
                    );

                    if (gameItemTry != null) {
                      context.read<LevelBloc>().add(
                        AddGameItemsEvent(items: [gameItemTry]),
                      );
                    }

                    //     setState(() {}); // Обновляем UI после добавления элемента
                  },
                ),
              ),

              if (state.lastDiscoveredItem != null && !_showMergeBanner)
                Positioned(
                  top: 100, // Позиционируем в верхней части экрана
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child:
                        state.lastDiscoveredItem == "field_cleared"
                            ? DiscoveryBanner(messageType: 'clear')
                            : DiscoveryBanner(
                              itemName:
                                  allImages
                                      .firstWhere(
                                        (item) =>
                                            item.id == state.lastDiscoveredItem,
                                      )
                                      .slug,
                              imagePath:
                                  allImages
                                      .firstWhere(
                                        (item) =>
                                            item.id == state.lastDiscoveredItem,
                                      )
                                      .assetPath,
                            ),
                  ),
                ),

              if (_showMergeBanner && _mergedItem != null)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(
                      0.5 * _bannerOpacityAnimation.value,
                    ),
                    child: MergeSuccessBanner(
                      resultItem: _mergedItem,
                      onClose: () async {
                        // Сохраняем необходимые данные до асинхронных операций
                        final bloc = context.read<LevelBloc>();
                        final targetItemId = _mergedItem?.id;
                        final isTargetItem =
                            targetItemId == bloc.state.targetItem;
                        final currentLevel = bloc.state.currentLevel;

                        try {
                          await _bannerAnimationController.reverse();

                          if (isTargetItem && mounted) {
                            bloc.add(LevelCompletedEvent());

                            await bloc.stream.firstWhere(
                              (state) => state.currentLevel > currentLevel,
                            );

                            if (mounted) {
                              setState(() {
                                _showMergeBanner = false;
                                _mergedItem = null;
                              });
                            }
                            return;
                          }
                        } catch (e) {
                          debugPrint('Ошибка анимации: $e');
                          if (mounted) {
                            setState(() {
                              _showMergeBanner = false;
                              _mergedItem = null;
                            });
                          }
                        }
                      },
                      opacityAnimation: _bannerOpacityAnimation,
                      scaleAnimation: _bannerScaleAnimation,
                    ),
                  ),
                ),

              Positioned(
                top: 100,
                left: 0,
                child: SlideTransition(
                  position: _hintPanelAnimation!,
                  child: _buildHintPanel(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleHintPanel() {
    setState(() {
      _showHintPanel = !_showHintPanel;
      if (_showHintPanel) {
        _hintPanelController?.forward();
      } else {
        _hintPanelController?.reverse();
      }
    });
  }

  /// Получаем координаты
  Offset _getCoorStatic(
    Map<String, int> params,
    double cellSize,
    double fieldTopOffset,
  ) {
    final x = params['gridX']! * cellSize + (cellSize / 2);

    final y =
        params['gridY']! * cellSize + (cellSize / 2) + _toolboxHeight.toInt();

    return Offset(x.toDouble(), y.toDouble());
  }

  /// Определяет ячейку сетки по координатам касания
  /// Возвращает Map с координатами ячейки {'x': x, 'y': y} или null, если касание вне поля
  Map<String, int> getCellFromCoordinates(
    Offset position,
    double cellSize,
    double fieldTopOffset,
  ) {
    // Преобразуем глобальные координаты в локальные относительно игрового поля
    final localX = position.dx;
    final localY = position.dy - fieldTopOffset;

    print('fieldTopOffset ${fieldTopOffset}');
    // Проверяем, что касание в пределах игрового поля
    // if (localX < 0 || localY < 0) return null;

    final cellX = (localX / cellSize).floor();
    final cellY = (localY / cellSize).floor();

    // Проверяем, что ячейка в пределах сетки
    //if (cellX >= gridColumns || cellY >= gridRows) return null;

    return {'gridX': cellX, 'gridY': cellY};
  }

  /// Определяет центр координат ближайшей ячейки имея координаты
  Offset getCoordinatesBox(
    Offset position,
    double cellSize,
    double fieldTopOffset,
  ) {
    print('StartPosition ${position}');
    // Преобразуем глобальные координаты в локальные относительно игрового поля
    final box = getCellFromCoordinates(position, cellSize, fieldTopOffset);
    print('box ${box}');

    final coor = _getCoorStatic(box, cellSize, fieldTopOffset);

    return coor;
  }

  void _handleClearField() async {
    print("Логика очистки экрана");
    // Анимируем кнопку
    await _clearButtonController.forward();
    await _clearButtonController.reverse();

    context.read<LevelBloc>().add(ClearGameFieldEvent());
  }

  // Обработчик начала перетаскивания элемента
  void _handleGlobalDragStart(DragStartDetails details) {
    final touchPosition = details.globalPosition;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(touchPosition);

    // Определяем координаты касания в терминах сетки
    final touchedX = (localPosition.dx / cellSize).floor();
    final touchedY = (localPosition.dy / cellSize).floor();

    /// stop
    final gameItems = context.read<LevelBloc>().state.gameItems ?? [];
    // Находим элемент по координатам
    final touchedItem = gameItems.firstWhereOrNull(
      (item) => item.gridX == touchedX && item.gridY == touchedY,
    );

    if (touchedItem != null) {
      _startDragging(touchedItem, touchPosition); // Начинаем перетаскивание
    }
  }

  void _handleDragEnd(DragEndDetails details) async {
    if (_draggedItem == null || _dragStartPosition == null) return;

    final item = _draggedItem!;
    final newX =
        ((item.gridX * cellSize + item.dragOffset.dx) / cellSize).round();
    final newY =
        ((item.gridY * cellSize + item.dragOffset.dy) / cellSize).round();

    // Если элемент перемещен в новую ячейку
    if (newX != item.gridX || newY != item.gridY) {
      // проверка слияния и слияния
      final mergeSuccess = await _checkForMerge(item, newX, newY);
      debugPrint('проверка слияния и слияния');
      if (mergeSuccess) {
        // Слияние успешно - элемент будет удален в mergeHandler
        _clearDraggedItem();
        return;
      }

      // Если слияние не удалось, пробуем переместить
      if (_isCellEmpty(newX, newY)) {
        _moveItemToNewPosition(item, newX, newY);
      } else {
        _returnItemToOriginalPosition(item);
      }
    } else {
      // Элемент не перемещен - возвращаем на место
      _returnItemToOriginalPosition(item);
    }

    _clearDraggedItem();
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
    // Можно добавить анимацию
    final updatedItem = item.copyWith(
      dragOffset: Offset.zero,
      tempOffset: item.dragOffset, // Для анимации
    );

    context.read<LevelBloc>().add(AddGameItemsEvent(items: [updatedItem]));

    // Запустить анимацию через TickerProvider
    // и постепенно обнулять tempOffset
  }

  void _clearDraggedItem() {
    _draggedItem = null;
    _dragStartPosition = null;
  }

  // Проверка, свободна ли ячейка
  bool _isCellEmpty(int x, int y) {
    final gameItems = context.read<LevelBloc>().state.gameItems ?? [];
    if (x < 0 || x >= gridColumns || y < 0 || y >= gridRows) {
      return false; // Ячейка за границами считается занятой
    }
    return !gameItems.any((item) => item.gridX == x && item.gridY == y);
  }

  // Проверка возможности слияния с соседними элементами
  // Проверка возможности слияния элементов в одной ячейке
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
    debugPrint('Проверяем слияние с каждым элементом в ячейке');
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
    context.read<LevelBloc>().add(RemoveGameItemsEvent(items: [item]));
    setState(() {
      _draggedItem = item; // Запоминаем перетаскиваемый элемент
      _dragStartPosition = startPosition; // Запоминаем начальную позицию
      //   debugPrint('///////////////// ${item.gridX} ${item.gridY} ${item}');
    });
    //  debugPrint('удалили объект');
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

  void _startHintTimer() {
    // Останавливаем предыдущий таймер, если был
    _hintTimer?.cancel();

    // Запускаем новый таймер
    _hintTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      final state = context.read<LevelBloc>().state;

      if (state.hintsState.lastHintTime != null &&
          !state.hintsState.hasPendingHint) {
        final now = DateTime.now();
        final nextHintTime = state.hintsState.lastHintTime!.add(
          const Duration(hours: 3),
        );

        if (now.isBefore(nextHintTime)) {
          setState(() {
            _timeUntilNextHint = nextHintTime.difference(now);
          });
        } else {
          setState(() {
            _timeUntilNextHint = Duration.zero;
          });
        }
      } else {
        setState(() {
          _timeUntilNextHint = Duration.zero;
        });
      }
    });
  }

  // Метод для форматирования времени в читаемый вид
  String _formatTimeRemaining(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  Widget _buildHintPanel(BuildContext context) {
    final _hintItem1 = 'water';
    final _hintItem2 = 'water';
    final _hintResult = 'cloud';

    return HintBanner(
      item1Id: _hintItem1!,
      item2Id: _hintItem2!,
      resultId: _hintResult!,
      onClose: () {
        setState(() {
          //    _showHintBanner = false;
        });
        // Здесь можно добавить логику после закрытия подсказки
      },
    );
  }

  Widget _buildHintPanel___OLD(BuildContext context) {
    final state = context.read<LevelBloc>().state;
    final hintsState = state.hintsState;
    final levelHints = state.hints;

    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          const Text(
            'Система подсказок',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Статус подсказок
          _buildHintStatusHeader(context),
          const SizedBox(height: 16),

          // Список подсказок уровня
          if (levelHints.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Доступные комбинации:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._buildLevelHintsList(context),
              ],
            ),
          const SizedBox(height: 16),
          _buildHintActionButtons(context),
        ],
      ),
    );
  }

  List<Widget> _buildLevelHintsList(BuildContext context) {
    final state = context.read<LevelBloc>().state;
    final hintsState = state.hintsState;
    final levelHints = state.hints;

    return levelHints.entries.map((entry) {
      final hintKey = entry.value.join('_');
      final isUsed = hintsState.usedHints.contains(hintKey);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            isUsed
                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                : const Icon(Icons.help_outline, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${entry.value[0]} + ${entry.value[1]} → ${entry.value[2]}',
                style: TextStyle(
                  color: isUsed ? Colors.grey : Colors.black,
                  decoration: isUsed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  void _showCurrentHint(BuildContext context) {
    final lastHint = context.read<LevelBloc>().state.lastDiscoveredItem;
    if (lastHint != null && lastHint.startsWith('hint_')) {
      final hintCombination = lastHint.replaceFirst('hint_', '').split('_');

      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Ваша подсказка'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${hintCombination[0]} + ${hintCombination[1]} → ${hintCombination[2]}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  const Text('Попробуйте создать этот предмет!'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  Widget _buildHintActionButtons(BuildContext context) {
    final state = context.read<LevelBloc>().state;
    final hintsState = state.hintsState;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7), // Полупрозрачный темный фон
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Кнопка получения подсказки
          if (hintsState.hasPendingHint)
            ElevatedButton.icon(
              icon: const Icon(Icons.lightbulb, color: Colors.black),
              label: const Text(
                'Использовать подсказку',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                context.read<LevelBloc>().add(UseHintEvent());
                _toggleHintPanel();
                _showCurrentHint(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          else if (hintsState.canGetFreeHint ||
              hintsState.paidHintsAvailable > 0)
            ElevatedButton.icon(
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text(
                'Получить подсказку',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                context.read<LevelBloc>().add(RequestHintEvent());
                _toggleHintPanel();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent.withOpacity(0.9),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          else
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: const Text(
                'Купить подсказки',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => _showBuyHintsDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange.withOpacity(0.9),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

          // Кнопка закрытия
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: _toggleHintPanel,
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  void _showBuyHintsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Купить подсказки'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBuyHintOption(ctx, 1, 10),
                _buildBuyHintOption(ctx, 3, 25),
                _buildBuyHintOption(ctx, 5, 40),
              ],
            ),
          ),
    );
  }

  // String _formatDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, "0");
  //   final hours = twoDigits(duration.inHours);
  //   final minutes = twoDigits(duration.inMinutes.remainder(60));
  //   final seconds = twoDigits(duration.inSeconds.remainder(60));
  //   return "$hours:$minutes:$seconds";
  // }

  Widget _buildBuyHintOption(BuildContext context, int amount, int price) {
    return ListTile(
      title: Text('$amount подсказка(и) за $price монет'),
      onTap: () {
        Navigator.pop(context);
        context.read<LevelBloc>().add(BuyHintsEvent(amount));
      },
    );
  }

  Widget _buildHintStatusHeader(BuildContext context) {
    final state = context.read<LevelBloc>().state;
    final hintsState = state.hintsState;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(1), // Полупрозрачный темный фон
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.9)),
      ),
      child: Column(
        children: [
          // Статус бесплатных подсказок
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.lightbulb_outline, size: 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Бесплатные:', style: TextStyle(color: Colors.white)),
                ],
              ),
              Text(
                '${3 - hintsState.freeHintsUsed}/3',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      hintsState.canGetFreeHint
                          ? Colors.lightGreenAccent
                          : Colors.redAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Статус платных подсказок
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.star, size: 18, color: Colors.amber),
                  SizedBox(width: 8),
                  Text('Платные:', style: TextStyle(color: Colors.white)),
                ],
              ),
              Text(
                '${hintsState.paidHintsAvailable}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Таймер до следующей подсказки
          if (!hintsState.canGetFreeHint && _timeUntilNextHint > Duration.zero)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: Colors.lightBlue),
                    SizedBox(width: 8),
                    Text(
                      'До следующей:',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Text(
                  _formatTimeRemaining(_timeUntilNextHint),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
