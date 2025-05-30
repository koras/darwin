import 'package:flutter/material.dart';
// level_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:darwin/data/levels_repository.dart';
import 'package:darwin/models/game_item.dart';
import 'package:darwin/services/hive_service.dart';

import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:darwin/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'dart:async'; // Для Timer

part 'level_event.dart';
part 'level_state.dart';
part 'level_bloc.g.dart'; // Добавлено для генерации

class LevelBloc extends Bloc<LevelEvent, LevelState> {
  final InAppPurchase _iap = InAppPurchase.instance;
  static const Set<String> _hintProductIds = {
    'hints_3',
    'hints_5',
    'hints_10',
    'hints_20',
  };
  StreamSubscription? _purchaseSubscription;

  LevelBloc() : super(LevelState.initial()) {
    _loadInitialState();

    on<LoadLevelEvent>(_onLoadLevel);
    on<LevelCompletedEvent>(_onLevelCompleted);
    on<ItemDiscoveredEvent>(_onItemDiscovered);
    // Добавьте этот обработчик
    on<ClearDiscoveryEvent>(_onClearDiscovery);
    on<AddGameItemsEvent>(_onAddGameItems);
    on<RemoveGameItemsEvent>(_onRemoveGameItems);
    on<MergeItemsEvent>(_onMergeItemsEvent);
    // Добавляем новый обработчик
    on<ShowLevelCompleteEvent>(_onShowLevelComplete);
    // очищаем игровое поле
    on<ClearGameFieldEvent>(_onClearGameField);

    // В конструкторе добавим обработчики
    on<ClearActiveHintEvent>(_onClearActiveHint);
    on<UseHintEvent>(_onUseHint);
    on<SetHintEvent>(_onSetHint);

    on<DecrementHint>(_onDecrementHint);

    on<SetHintItem>(_onSetHintItem);
    on<HintTimerTicked>(_onHintTimerTicked);

    // Добавляем новые обработчики
    on<BuyHintsEvent>(_onBuyHints);
    on<RestorePurchasesEvent>(_onRestorePurchases);
    on<IAPInitializedEvent>(_initializeIAP);

    // Добавляем инициализацию IAP
    add(IAPInitializedEvent());

    on<MusicChange>(_onMusicChange);
    on<LocalChange>(_onLocalChange);
  }

  Future<void> _loadInitialState() async {
    try {
      final box = await Hive.openBox<LevelState>('settings');
      final savedState = box.get('main');
      if (savedState != null) {
        emit(savedState);
      }
    } catch (e) {
      debugPrint('Error loading initial state: $e');
    }
  }

  Future<void> _saveState(LevelState newState) async {
    try {
      final box = await Hive.openBox<LevelState>('settings');
      await box.put('main', newState);
    } catch (e) {
      debugPrint('Error saving state: $e');
    }
  }

  void _onClearGameField(ClearGameFieldEvent event, Emitter<LevelState> emit) {
    emit(state.copyWith(gameItems: []));
  }

  void _onMusicChange(MusicChange event, Emitter<LevelState> emit) {
    final newState = state.copyWith(soundsEnabled: event.soundsEnabled);
    _saveState(newState);
    emit(newState);
  }

  void _onLocalChange(LocalChange event, Emitter<LevelState> emit) {
    try {
      final newState = state.copyWith(locale: event.locale);
      emit(newState);
      _saveState(newState);
    } catch (e) {
      debugPrint('Error changing locale: $e');
      // Можно добавить обработку ошибки, например:
      // addError(e, stackTrace);
    }
  }

  // событие слияния
  void _onMergeItemsEvent(MergeItemsEvent event, Emitter<LevelState> emit) {
    /// Если подсказок нет, то надо включить учёт времени
    ///
    ///
    debugPrint(
      'Текущая подсказка перед слиянием: ${state.hintsState.currentHint}',
    );
    debugPrint(
      'подсказка найдена ${event.itemToAdd.id} == ${state.hintsState.currentHint}',
    );
    if (event.itemToAdd.id == state.hintsState.currentHint) {
      debugPrint('подсказка найдена');
      emit(
        state.copyWith(
          hintsState: state.hintsState.copyWith(
            hasPendingHint: false,
            currentHint: '',
          ),
        ),
      );
    }

    // final now = DateTime.now();

    if (state.hintsState.freeHints == 0 &&
        state.hintsState.paidHintsAvailable == 0 &&
        //  !state.hintsState.timeHintAvailable &&
        !state.hintsState.hasPendingHint) {
      // запускаем отсчёт времени. Надо знать когда будет доступна подсказка

      debugPrint('запускаем......................');
      add(UseHintEvent());
      _startHintTimer();
    } else {
      print('Нет просчёта времени');
    }

    final currentItems = state.gameItems ?? [];

    // Удаляем старые элементы
    final updatedItems =
        currentItems
            .where((item) => !event.itemsToRemove.any((r) => r.key == item.key))
            .toList();

    // Добавляем новый элемент
    updatedItems.add(event.itemToAdd);

    // final newDiscoveredItemsLevel = [
    //   ...state.discoveredItemsLevel.where((item) => item != state.hintsState.currentHint),
    //   state.hintsState.currentHint,
    // ];
    debugPrint(' Добавляем новый элемент ${event.itemToAdd.id}');
    final newDiscoveredItemsLevel = [
      ...state.discoveredItemsLevel.where((item) => item != event.itemToAdd.id),
      event.itemToAdd.id,
    ];

    emit(
      state.copyWith(
        discoveredItemsLevel: newDiscoveredItemsLevel,
        gameItems: updatedItems,
      ),
    );
  }

  void _onUseHint(UseHintEvent event, Emitter<LevelState> emit) {
    final now = DateTime.now();
    emit(
      state.copyWith(
        hintsState: state.hintsState.copyWith(
          hasPendingHint: false,
          currentHint: '',
        ),
      ),
    );
    print(
      '+++++++++++++++state.hintsState.freeHints ${state.hintsState.freeHints}',
    );

    if (state.hintsState.freeHints == 0 &&
        state.hintsState.paidHintsAvailable == 0) {
      if (!state.hintsState.timeHintAvailable) {
        // ставим счётчик
        debugPrint('ставим счётчик+++++++++++++');

        emit(
          state.copyWith(
            hintsState: state.hintsState.copyWith(
              lastHintTime: now,
              timeHintAvailable: true,
            ),
          ),
        );

        _startHintTimer();
      }
    }
  }

  /**
   * метод для удаления элементов. 
   * 
   */
  void _onRemoveGameItems(
    RemoveGameItemsEvent event,
    Emitter<LevelState> emit,
  ) {
    // Если gameItems null, просто возвращаем текущее состояние
    if (state.gameItems == null) {
      return;
    }
    // Создаем новый список без удаляемых элементов
    final newItems =
        state.gameItems!
            .where((item) => !event.items.any((e) => e.key == item.key))
            .toList();

    // print('Результат после удаления: ${newItems.map((e) => e.id).toList()}');

    emit(state.copyWith(gameItems: newItems));
  }

  /// Добавление элементов на игровое поле
  void _onAddGameItems(AddGameItemsEvent event, Emitter<LevelState> emit) {
    // print('Добавляем элемент ${state.gameItems}');

    final currentGameItems = state.gameItems ?? [];

    // логика

    emit(state.copyWith(gameItems: [...currentGameItems, ...event.items]));
  }

  String _getLocalizedString(AppLocalizations l10n, String key) {
    try {
      return (l10n as dynamic)[key] as String? ?? key;
    } catch (e) {
      return key; // Fallback
    }
  }

  void _onLoadLevel(LoadLevelEvent event, Emitter<LevelState> emit) {
    final currentDiscovered = state.discoveredItems;
    // Начальные предметы уровня + уже открытые
    // final allAvailable =
    //     [
    //       ...List<String>.from(event.imageItems),
    //       ...currentDiscovered,
    //     ].toSet().toList(); // Убираем дубликаты

    emit(
      LevelState(
        currentLevel: event.levelId,
        availableItems: event.imageItems,
        discoveredItemsLevel: [],
        discoveredItems: currentDiscovered,
        targetItem: event.result,
        levelTitle: event.title,
        hints: event.hints,
        background: event.background,
        freeHints: event.freeHints,
        timeHintWait: event.timeHintWait,
        soundsEnabled: state.soundsEnabled,
        locale: state.locale,
      ),
    );
  }

  void _onClearDiscovery(ClearDiscoveryEvent event, Emitter<LevelState> emit) {
    emit(state.copyWith(lastDiscoveredItem: null));
  }

  // все новые предметы здесь
  void _onItemDiscovered(ItemDiscoveredEvent event, Emitter<LevelState> emit) {
    //   print('${state.hintsState.currentHint} state.hintsState.currentHint ');
    //   print('${event.itemId} event.itemId');

    if (event.itemId == state.hintsState.currentHint) {
      debugPrint(' забираем подсказку ${state.hintsState.currentHint} ');

      /// забираем подсказку
      emit(
        state.copyWith(
          hintsState: state.hintsState.copyWith(
            hasPendingHint: false,
            currentHint: '',
          ),
        ),
      );
    }

    debugPrint('Смотрим state.discoveredItems');

    final newDiscoveredItemsLevel = [
      ...state.discoveredItemsLevel.where((item) => item != event.itemId),
      event.itemId,
    ];

    // Проверяем, был ли предмет ранее доступен
    final isNew = !state.availableItems.contains(event.itemId);

    final newAvailable = [...state.availableItems, event.itemId];
    emit(
      state.copyWith(
        discoveredItemsLevel: newDiscoveredItemsLevel,
        //    discoveredItems: newDiscovered,
        availableItems: newAvailable,
        //   lastDiscoveredItem: isNew ? event.itemId : null,
      ),
    );

    if (state.discoveredItems.contains(event.itemId)) return;

    debugPrint('Нашли новый элемент _onItemDiscovered ${event.itemId}');
    final newDiscovered = [...state.discoveredItems, event.itemId];

    emit(
      state.copyWith(
        //   discoveredItemsLevel: newDiscoveredItemsLevel,
        discoveredItems: newDiscovered,
        //    availableItems: newAvailable,
        lastDiscoveredItem: isNew ? event.itemId : null,
      ),
    );
  }

  ///
  /// Меняем уровень
  ///
  void _onLevelCompleted(
    LevelCompletedEvent event,
    Emitter<LevelState> emit,
  ) async {
    final BuildContext context; // Добавляем контекст
    final nextLevel = state.currentLevel + 1;
    print('Переход на уровень ${nextLevel}  ');

    // Сохраняем новый уровень в Hive
    await HiveService.saveLevel(nextLevel);

    // final _levelsRepository = LevelsRepository.initialize(event.context);
    // Получаем локализованные данные
    //   final localizedLevels = LevelsRepository.getLocalizedLevels(event.context);

    // Загружаем данные уровня
    //  final levelData = localizedLevels[nextLevel] ?? localizedLevels[1]!;
    //  final firstLevelData = localizedLevels[1]!;

    final levelData = LevelsRepository.levelsData[nextLevel]!;

    //   if (LevelsRepository.getLocalizedLevels()) {
    // Сохраняем все открытые предметы
    final currentDiscovered = state.discoveredItems;
    // Объединяем начальные предметы нового уровня и открытые ранее
    // final allAvailable =
    //     [
    //       ...List<String>.from(levelData['imageItems']),
    //       ...currentDiscovered,
    //     ].toSet().toList();

    emit(
      LevelState(
        currentLevel: nextLevel,
        //  availableItems: allAvailable,
        availableItems: levelData['imageItems'],
        discoveredItemsLevel: [],
        discoveredItems: currentDiscovered, // Переносим все открытые
        targetItem: levelData['result'],
        levelTitle: levelData['title'],
        hints: levelData['hints'],
        background: levelData['background'],
        freeHints: levelData['freeHints'],
        timeHintWait: levelData['timeHintWait'],
        soundsEnabled: state.soundsEnabled,
        locale: state.locale,
      ),
    );

    print(
      'Уровень $nextLevel успешно загружен. Новый targetItem: ${levelData['result']}',
    );
    //   }
  }

  void _onShowLevelComplete(
    ShowLevelCompleteEvent event,
    Emitter<LevelState> emit,
  ) {
    emit(
      state.copyWith(showLevelComplete: true, completedItemId: event.itemId),
    );
  }

  bool get timeUntilNextHint {
    final now = DateTime.now();
    if (state.hintsState.timeHintAvailable) {
      //  return false;
    }

    final passed = now.difference(state.hintsState.lastHintTime!);
    final remaining = state.hintsState.timeHintWait - passed.inMinutes;
    // доступна подсказка или нет?
    // print('доступна подсказка или нет?');
    return remaining > 0;
  }

  ///
  /// убавляем количество подсказок
  ///
  void _onDecrementHint(DecrementHint event, Emitter<LevelState> emit) {
    // emit(
    //   state.copyWith(
    //     hintsState: state.hintsState.copyWith(hasPendingHint: true),
    //   ),
    // );

    print('проверяем, есть ли у нас подсказки');
    if (state.hintsState.freeHints > 0) {
      // сперва если есть бесплатные, мы вычитаем именно бесплатные
      emit(
        state.copyWith(
          hintsState: state.hintsState.copyWith(
            hasPendingHint: true,
            freeHints: state.hintsState.freeHints - 1,
            countHintsAvailable:
                state.hintsState.freeHints -
                1 +
                state.hintsState.paidHintsAvailable,
          ),
        ),
      );
      print('--- убавляем freeHints ${state.hintsState.freeHints} = ');
      return;
    }

    if (state.hintsState.paidHintsAvailable > 0) {
      // проверяем, если есть купленные подсказки, то вычитаем из купленных подсказок;
      emit(
        state.copyWith(
          hintsState: state.hintsState.copyWith(
            hasPendingHint: true,
            paidHintsAvailable: state.hintsState.paidHintsAvailable - 1,
            countHintsAvailable:
                state.hintsState.freeHints +
                state.hintsState.paidHintsAvailable -
                1,
          ),
        ),
      );

      print('--- убавляем paidHintsAvailable ${state.hintsState.freeHints} = ');
      return;
    }

    ///подсказок больше нет активируем время
  }

  // }

  void _onClearActiveHint(
    ClearActiveHintEvent event,
    Emitter<LevelState> emit,
  ) {
    //   emit(
    //     state.copyWith(hintsState: state.hintsState.copyWith(currentHint: null)),
    //   );
  }

  void _onSetHintItem(SetHintItem event, Emitter<LevelState> emit) {
    emit(
      state.copyWith(
        hintsState: state.hintsState.copyWith(
          currentHint: event.currentHint,
          hasPendingHint: true,
        ),
      ),
    );
  }

  Timer? _hintTimer;
  // Таймер обновляет оставшееся время
  void _onHintTimerTicked(HintTimerTicked event, Emitter<LevelState> emit) {
    // debugPrint('каждая секунда. ');

    final hintsState = state.hintsState;
    final now = DateTime.now();
    if (hintsState.lastHintTime != null) {
      final passed = now.difference(hintsState.lastHintTime!);
      //      final remaining = 1800 - passed.inSeconds; // 30 минут в секундах
      final remaining = 5 - passed.inSeconds; // 30 минут в секундах

      // Форматируем время "MM:SS"
      final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
      final seconds = (remaining % 60).toString().padLeft(2, '0');
      final timeStr = '$minutes:$seconds';
      emit(
        state.copyWith(
          timeStr: timeStr,

          //timeUntilNextHint: timeStr
        ),
      );

      debugPrint(' timeStr ${timeStr}');

      // Останавливаем таймер, если время вышло
      if (remaining <= 0) {
        _hintTimer?.cancel();

        /// даём подсказку

        debugPrint('даём подсказку');
        emit(
          state.copyWith(
            hintsState: hintsState.copyWith(
              timeHintAvailable: false,
              lastHintTime: null,
              freeHints: 1,
            ),
            timeStr: null,
            //     timeUntilNextHint: null,
          ),
        );
      }
    }
  }

  void _startHintTimer() {
    debugPrint('_startHintTimer');
    _hintTimer?.cancel();
    _hintTimer = Timer.periodic(
      Duration(seconds: 1),
      (_) => add(HintTimerTicked()),
    );
  }

  void _onSetHint(SetHintEvent event, Emitter<LevelState> emit) {
    // emit(
    //   state.copyWith(
    //     hintsState: state.hintsState.copyWith(hasPendingHint: true),
    //   ),
    // );
  }

  //  оплата
  Future<void> _initializeIAP(
    IAPInitializedEvent event,
    Emitter<LevelState> emit,
  ) async {
    try {
      debugPrint('[IAP] Starting IAP initialization...');

      // 1. Проверяем доступность IAP
      final isAvailable = await _iap.isAvailable();
      debugPrint('[IAP] IAP available: $isAvailable');

      if (!isAvailable) {
        debugPrint('[IAP] In-App Purchases not available on this device');
        return;
      }

      // 2. Загружаем доступные продукты
      debugPrint('[IAP] Loading products...');
      final response = await _iap.queryProductDetails(_hintProductIds);
      debugPrint('[IAP] Found ${response.productDetails.length} products');

      // 3. Подписываемся на поток покупок
      debugPrint('[IAP] Setting up purchase listener...');
      _purchaseSubscription = _iap.purchaseStream.listen((purchases) {
        debugPrint('[IAP] Received ${purchases.length} purchase updates');

        for (final purchase in purchases) {
          debugPrint(
            '[IAP] Processing purchase: ${purchase.productID}, status: ${purchase.status}',
          );

          if (purchase.status == PurchaseStatus.purchased) {
            final hints = _getHintsCountFromProductId(purchase.productID);
            debugPrint(
              '[IAP] Purchased ${hints} hints (product: ${purchase.productID})',
            );

            if (hints > 0 && purchase.pendingCompletePurchase) {
              debugPrint('[IAP] Completing purchase...');
              _iap.completePurchase(purchase);

              debugPrint('[IAP] Adding ${hints} hints via BuyHintsEvent');
              add(BuyHintsEvent(hints));
            }
          }
        }
      });

      debugPrint('[IAP] Initialization completed successfully');
    } catch (e, stackTrace) {
      debugPrint('[IAP] Initialization error: $e');
      debugPrint('[IAP] Stack trace: $stackTrace');
    }
  }

  Future<void> _onBuyHints(
    BuyHintsEvent event,
    Emitter<LevelState> emit,
  ) async {
    final hintsToAdd = event.count.toInt();

    print('попутка купить _onBuyHints');
    emit(
      state.copyWith(
        hintsState: state.hintsState.copyWith(
          paidHintsAvailable: state.hintsState.paidHintsAvailable + hintsToAdd,
          countHintsAvailable:
              state.hintsState.freeHints +
              state.hintsState.paidHintsAvailable +
              hintsToAdd,
        ),
      ),
    );
  }

  Future<void> _onRestorePurchases(
    RestorePurchasesEvent event,
    Emitter<LevelState> emit,
  ) async {
    print(' _onRestorePurchases');
    try {
      await _iap.restorePurchases();
    } catch (e) {
      debugPrint('Restore purchases error: $e');
    }
  }

  int _getHintsCountFromProductId(String productId) {
    switch (productId) {
      case 'hints_3':
        return 3;
      case 'hints_5':
        return 5;
      case 'hints_10':
        return 10;
      case 'hints_20':
        return 20;
      default:
        return 0;
    }
  }

  // Обновляем метод close для отписки
  @override
  Future<void> close() {
    _purchaseSubscription?.cancel();
    return super.close();
  }
}

class HintCombination {
  final String item1;
  final String item2;
  final String result;

  HintCombination(this.item1, this.item2, this.result);
}
