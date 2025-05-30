import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // Для использования firstWhereOrNull

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darwin/gen_l10n/app_localizations.dart';
import 'package:darwin/data/levels_repository.dart';
import 'package:darwin/screens/hintBanner.dart';
import 'package:darwin/models/game_item.dart';
import 'package:darwin/data/image_item.dart';
import 'package:darwin/logic/game_field_manager.dart';
import 'package:darwin/logic/merge_handler.dart';
import 'package:darwin/logic/merge_logic.dart';
import 'package:darwin/logic/hint_manager.dart';
import 'package:darwin/widgets/game_field.dart';
import 'package:darwin/widgets/toolbox_panel.dart';
import 'package:darwin/widgets/game_panel.dart';
import 'package:darwin/widgets/bottom_app_bar_widget.dart';
import 'package:darwin/data/merge_rules.dart';
import 'package:darwin/bloc/level_bloc.dart';
import 'package:darwin/screens/discoveryBanner.dart';
import 'package:darwin/screens/mergeSuccessBanner.dart';
import 'package:darwin/screens/waitOrBuyHintBanner.dart';
import 'package:darwin/data/audio_manager.dart';

// Основной виджет игры, объединяющий игровое поле и панель инструментов
class MergeGame extends StatefulWidget {
  const MergeGame({super.key});

  @override
  MergeGameState createState() => MergeGameState();
}

class MergeGameState extends State<MergeGame> with TickerProviderStateMixin {
  late AnimationController _clearButtonController;
  late Animation<double> _clearButtonAnimation;

  late HintManager _hintManager;
  // для плавного завершения уровня
  late AnimationController _bannerAnimationController;
  late Animation<double> _bannerOpacityAnimation;
  late Animation<double> _bannerScaleAnimation;
  // Первый элеменит слияния для подсказки
  String? _hintItem1;
  // Второй элеменит слияния для подсказки
  String? _hintItem2;
  // Результат слияния для подсказки
  String? _hintResult;
  // количество подсказок
  int _countHints = 0;

  bool _showHintPanel = false;
  AnimationController? _hintPanelController;
  AnimationController? _hintPayPanelController;

  Animation<Offset>? _hintBunnerAnimation;
  Animation<Offset>? _hintPayBunnerAnimation;

  // Добавляем BLoC
  // late final LevelBloc _levelBloc;

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

    //  final l10n = AppLocalizations.of(context)!;

    final level = 1;

    // final levelData = LevelsRepository.getLocalizedLevels(context)[level];

    final levelData = LevelsRepository.levelsData[level]!;

    //  final levelData = LevelsRepository.levelsData[level]!;

    context.read<LevelBloc>().add(
      LoadLevelEvent(
        level,
        levelData['title'],
        levelData['result'],
        levelData['hints'],
        levelData['imageItems'],
        levelData['background'],
        levelData['freeHints'],
        levelData['timeHintWait'],
      ),
    );

    _hintManager = HintManager(context, mergeRules);
    // _startHintTimer();

    _fieldManager = FieldManager(
      getItems: () => context.read<LevelBloc>().state.gameItems ?? [],
      maxItems: 25, // Укажите нужные значения
      maxSameType: 25,
      rows: 5,
      columns: 5,
    );
    // устанавливаем

    // _levelBloc = LevelBloc();

    _mergeHandler = MergeHandler(
      context: context,
      onMergeComplete: (mergedItem) {
        if (mergedItem.id == context.read<LevelBloc>().state.targetItem) {
          context.read<LevelBloc>().add(LevelCompletedEvent(context: context));
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

    _hintPayPanelController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _hintBunnerAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _hintPanelController!, curve: Curves.easeInOut),
    );

    _hintPayBunnerAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _hintPayPanelController!,
        curve: Curves.easeInOut,
      ),
    );
  }

  String get timeUntilNextHint {
    final now = DateTime.now();
    final passed = now.difference(
      context.read<LevelBloc>().state.hintsState.lastHintTime!,
    );
    final remaining = 30 - passed.inMinutes;

    return remaining > 0 ? 'Доступно через $remaining мин' : 'Доступно сейчас';
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
            if (mergedItem.id == context.read<LevelBloc>().state.targetItem) {
              debugPrint('banner');
              context.read<LevelBloc>().add(
                ShowLevelCompleteEvent(itemId: mergedItem.id),
              );

              setState(() {
                _mergedItem = mergedItem;

                AudioManager.playNextLevelSound();
                debugPrint('ПОБЕДА');
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
              // Positioned.fill(
              //   child: DecoratedBox(
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image:
              //             Image.asset(
              //               'background/${context.read<LevelBloc>().state.background}',
              //             ).image,
              //         fit: BoxFit.fitWidth, // Растягиваем по ширине
              //         alignment: Alignment.topCenter, // Выравниваем по верху
              //         repeat: ImageRepeat.repeatY,
              //       ),
              //     ),
              //   ),
              // ),
              Positioned.fill(
                child: FractionallySizedBox(
                  heightFactor:
                      0.82, // Занимает 80% высоты (оставляет 20% снизу)
                  alignment: Alignment.topCenter,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            Image.asset(
                              'assets/background/${context.read<LevelBloc>().state.background}',
                            ).image,
                        fit: BoxFit.fitHeight, // Растягиваем по ширине
                        alignment: Alignment.topCenter,
                      ),
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
                  name: AppLocalizations.of(context)!.task_level,
                  stars: 100,
                  taskDescription: state.levelTitle,
                  time: context.read<LevelBloc>().state.timeStr ?? '',
                  onHintPressed: () {
                    _toggleHintPanel();
                  },
                  onClearPressed: _handleClearField, // Изменяем обработчик () {
                  // Логика очистки экрана
                  //     scoreImagePath:
                  //        'assets/images/score_icon.png', // Ваш путь к картинке,
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
                    final gameItemTry = _fieldManager.tryAddItem(
                      context: context,
                      item: gameItem,
                    );

                    if (gameItemTry != null) {
                      context.read<LevelBloc>().add(
                        AddGameItemsEvent(items: [gameItemTry]),
                      );
                    }
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
                      context: context,
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
                            bloc.add(LevelCompletedEvent(context: context));

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
                  position: _hintBunnerAnimation!,
                  child: _buildHintPanel(context),
                ),
              ),
              Positioned(
                top: 100,
                left: 0,
                child: SlideTransition(
                  position: _hintPayBunnerAnimation!,
                  child: _buildPayPanel(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // у нас есть подсказки, теперь надо получить подсказку. Мы подразумеваем что
  // пользователь уже имеет открытый элемент, и надо дать пользователю
  // именно элемент которого у него нет
  // Соответственно, надо взять подсказки и вычесть элементы которые уже открыты.
  // при нахождении. При это мы не даём ему воспользоваться следующей подсказкой,
  // пока не соеденить два предмета. Но при этом мы можем показать ему ту же подсказку
  // чтобы пользователь понимал что с чем соеденить.

  Future<void> _toggleHintPanel() async {
    final state = context.read<LevelBloc>().state;
    final hintsState = state.hintsState;
    // Есть или бесплатные или платные подсказки.

    if (hintsState.freeHints > 0 ||
        hintsState.paidHintsAvailable > 0 ||
        hintsState.hasPendingHint) {
      // у нас есть открытая подсказка
      if (!hintsState.hasPendingHint) {
        // что-то видимо есть.
        context.read<LevelBloc>().add(DecrementHint());
        // помечаем что подсказка активна и не использована
        debugPrint('вычисляем подсказки');
        // когда мы открываем подсказку мы помечаем её как прочитанную
        // Ждем завершения обработки события
        await Future.delayed(Duration.zero);
      } else {
        debugPrint('не забираем подсказку');
      }

      final components = await _hintManager.showHint();
      if (components != null) {
        // это надо для баннера
        setState(() {
          _hintItem1 = components['item1'];
          _hintItem2 = components['item2'];
          _hintResult = components['result'];
        });

        debugPrint('-------------------------------${components['result']}');

        context.read<LevelBloc>().add(SetHintItem(components['result']!));
        //    context.read<LevelBloc>().add(SetHintItem(_hintResult!));
      }
      // Теперь получаем актуальное состояние после уменьшения
      final updatedState = context.read<LevelBloc>().state;

      setState(() {
        _countHints = updatedState.hintsState.countHintsAvailable;
        _showHintPanel = !_showHintPanel;
        if (_showHintPanel) {
          AudioManager.playOpenHintSound();
          _hintPanelController?.forward();
          //    _hintPayPanelController?.forward();
        } else {
          debugPrint('закрываем подсказку');
          _hintPanelController?.reverse();
          //  _hintPayPanelController?.forward();
        }
      });
    } else {
      debugPrint('доступные подсказки отсутствуют, идём за покупками ) ');
      _hintPayPanelController?.forward();
      // предлагаем купить подсказку
    }
  }

  void _handleClearField() async {
    AudioManager.playClearSound();
    debugPrint("Логика очистки экрана");
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

      if (mergeSuccess) {
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

  // Проверка возможности слияния с соседними элементами и элементов в одной ячейке
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
    // Проверяем слияние с каждым элементом в ячейке
    for (final item in itemsInCell) {
      if (getMergeResult(movedItem.id, item.id) != null) {
        final result = await _mergeHandler.tryMergeItems(movedItem, item);
        return result;
      }
    }

    AudioManager.playMergeFailSound();
    return false;
  }

  // Начало перетаскивания элемента
  void _startDragging(GameItem item, Offset startPosition) {
    context.read<LevelBloc>().add(RemoveGameItemsEvent(items: [item]));
    setState(() {
      _draggedItem = item; // Запоминаем перетаскиваемый элемент
      _dragStartPosition = startPosition; // Запоминаем начальную позицию
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

  void onBuyHints(count) {
    debugPrint('onBuy5Hints');
  }

  Widget _buildPayPanel(BuildContext context) {
    DateTime lastHintTime = DateTime.now(); // Время последней подсказки
    Duration cooldownPeriod = Duration(minutes: 30); // Время ожидания

    Duration remainingTime = lastHintTime
        .add(cooldownPeriod)
        .difference(DateTime.now());
    // Проверка, что время не отрицательное
    if (remainingTime.isNegative) {
      remainingTime = Duration.zero;
    }

    // if (_showHintPanel) {
    //   print('_showHintPanel true');
    // } else {
    //   print(' _showHintPanel false');
    // }

    return WaitOrBuyHintBanner(
      // cointHint: _countHints,
      remainingTime: remainingTime,
      onBuyHints: (count) => onBuyHints(count),
      onClose: () {
        setState(() {
          //      _showHintPanel = !_showHintPanel;
          debugPrint('Логика покупки');
          _hintPayPanelController?.reverse();
          // Логика подсказки
          //    _showHintBanner = false;
        });
        // Здесь можно добавить логику после закрытия подсказки
      },
    );
  }

  /// показываем баннер подсказок
  Widget _buildHintPanel(BuildContext context) {
    if (_hintItem1 != null && _hintItem2 != null && _hintResult != null) {
      return HintBanner(
        //    context: context,
        item1Id: _hintItem1!,
        item2Id: _hintItem2!,
        resultId: _hintResult!,
        cointHint: _countHints,
        onClose: () {
          setState(() {
            _showHintPanel = !_showHintPanel;
            debugPrint('Логика подсказки');
            _hintPanelController?.reverse();
            // Логика подсказки
            //    _showHintBanner = false;
          });
          // Здесь можно добавить логику после закрытия подсказки
        },
      );
    } else {
      return Text('У вас нет подсказок');
    }
  }
}
