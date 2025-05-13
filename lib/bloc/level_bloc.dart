// level_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'levels_repository.dart';
import '../models/game_item.dart';
import '../services/hive_service.dart';

import 'package:hive/hive.dart';
part 'level_event.dart';
part 'level_state.dart';
part 'level_bloc.g.dart'; // Добавлено для генерации

class LevelBloc extends Bloc<LevelEvent, LevelState> {
  LevelBloc() : super(LevelState.initial()) {
    // Загружаем сохраненный уровень
    final savedLevel = HiveService.loadLevel();

    // Загружаем данные уровня
    final levelData =
        LevelsRepository.levelsData[savedLevel] ??
        LevelsRepository.levelsData[1]!;

    final firstLevelData = LevelsRepository.levelsData[1]!;

    // Загружаем первый уровень при инициализации
    emit(
      LevelState(
        currentLevel: savedLevel,
        availableItems: List<String>.from(levelData['imageItems']),
        discoveredItems: List<String>.from(levelData['imageItems']),
        targetItem: levelData['result'],
        levelTitle: levelData['title'],
        hints: levelData['hints'],
      ),
    );

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
    on<RequestHintEvent>(_onRequestHint);
    on<ClearActiveHintEvent>(_onClearActiveHint);
    on<UseHintEvent>(_onUseHint);

    on<DecrementHint>(_onDecrementHint);

    //  on<BuyHintsEvent>(_onBuyHints);
    // on<MarkHintUsedEvent>(_onMarkHintUsed);
  }

  void _onClearGameField(ClearGameFieldEvent event, Emitter<LevelState> emit) {
    emit(state.copyWith(gameItems: []));
  }

  void _onMergeItemsEvent(MergeItemsEvent event, Emitter<LevelState> emit) {
    final currentItems = state.gameItems ?? [];

    // Удаляем старые элементы
    final updatedItems =
        currentItems
            .where((item) => !event.itemsToRemove.any((r) => r.key == item.key))
            .toList();

    // Добавляем новый элемент
    updatedItems.add(event.itemToAdd);

    emit(state.copyWith(gameItems: updatedItems));
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

  void _onLoadLevel(LoadLevelEvent event, Emitter<LevelState> emit) {
    print('Загрузка уровня ${event.levelId}');
    final levelData = LevelsRepository.levelsData[event.levelId];
    if (levelData != null) {
      // Сохраняем уже открытые предметы
      final currentDiscovered = state.discoveredItems;
      // Начальные предметы уровня + уже открытые
      final allAvailable =
          [
            ...List<String>.from(levelData['imageItems']),
            ...currentDiscovered,
          ].toSet().toList(); // Убираем дубликаты

      emit(
        LevelState(
          currentLevel: event.levelId,
          availableItems: allAvailable,
          discoveredItems: currentDiscovered,
          targetItem: levelData['result'],
          levelTitle: levelData['title'],
          hints: levelData['hints'],
        ),
      );
    } else {
      print('Уровень ${event.levelId} не найден');
    }
  }

  void _onClearDiscovery(ClearDiscoveryEvent event, Emitter<LevelState> emit) {
    emit(state.copyWith(lastDiscoveredItem: null));
  }

  void _onItemDiscovered(ItemDiscoveredEvent event, Emitter<LevelState> emit) {
    if (state.discoveredItems.contains(event.itemId)) return;

    // Проверяем, был ли предмет ранее доступен
    final isNew = !state.availableItems.contains(event.itemId);

    final newDiscovered = [...state.discoveredItems, event.itemId];
    final newAvailable = [...state.availableItems, event.itemId];

    emit(
      state.copyWith(
        discoveredItems: newDiscovered,
        availableItems: newAvailable,
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
    final nextLevel = state.currentLevel + 1;
    print('Переход на уровень ${nextLevel}  ');

    // Сохраняем новый уровень в Hive
    await HiveService.saveLevel(nextLevel);

    final levelData = LevelsRepository.levelsData[nextLevel]!;

    if (LevelsRepository.levelsData.containsKey(nextLevel)) {
      // Сохраняем все открытые предметы
      final currentDiscovered = state.discoveredItems;
      // Объединяем начальные предметы нового уровня и открытые ранее
      final allAvailable =
          [
            ...List<String>.from(levelData['imageItems']),
            ...currentDiscovered,
          ].toSet().toList();

      emit(
        LevelState(
          currentLevel: nextLevel,
          availableItems: allAvailable,
          discoveredItems: currentDiscovered, // Переносим все открытые
          targetItem: levelData['result'],
          levelTitle: levelData['title'],
          hints: levelData['hints'],
        ),
      );

      print(
        'Уровень $nextLevel успешно загружен. Новый targetItem: ${levelData['result']}',
      );
    }
  }

  void _onShowLevelComplete(
    ShowLevelCompleteEvent event,
    Emitter<LevelState> emit,
  ) {
    emit(
      state.copyWith(showLevelComplete: true, completedItemId: event.itemId),
    );
  }

  void _onDecrementHint(DecrementHint event, Emitter<LevelState> emit) {
    print('проверяем, есть ли у нас подсказки');

    if (state.hintsState.freeHints > 0) {
      print('--- убавляем freeHints ${state.hintsState.freeHints}');
      // сперва если есть бесплатные, мы вычитаем именно бесплатные

      emit(
        state.copyWith(
          hintsState: state.hintsState.copyWith(
            freeHints: state.hintsState.freeHints - 1,
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
            paidHintsAvailable: state.hintsState.paidHintsAvailable - 1,
          ),
        ),
      );
      return;
    }
  }

  String? _findUnusedHint(LevelState state) {
    for (final hint in state.hints) {
      if (!state.hintsState.usedHints.contains(hint)) {
        return hint;
      }
    }
    return null;
  }

  // Обработчики:
  void _onRequestHint(RequestHintEvent event, Emitter<LevelState> emit) {
    final currentHints = state.hintsState;

    // Если уже есть активная подсказка - ничего не делаем
    if (currentHints.hasActiveHint) return;

    final unusedHint = _findUnusedHint(state);
    if (unusedHint == null) {
      emit(state.copyWith(lastDiscoveredItem: 'all_hints_used'));
      return;
    }

    if (currentHints.canGetFreeHint) {
      emit(
        state.copyWith(
          hintsState: currentHints.copyWith(
            freeHintsUsed: currentHints.freeHintsUsed + 1,
            lastHintTime: DateTime.now(),
            currentHint: unusedHint,
            usedHints: [...currentHints.usedHints, unusedHint],
          ),
          lastDiscoveredItem: 'hint_$unusedHint',
        ),
      );
    } else if (currentHints.paidHintsAvailable > 0) {
      emit(
        state.copyWith(
          hintsState: currentHints.copyWith(
            paidHintsAvailable: currentHints.paidHintsAvailable - 1,
            currentHint: unusedHint,
            usedHints: [...currentHints.usedHints, unusedHint],
          ),
          lastDiscoveredItem: 'hint_$unusedHint',
        ),
      );
    } else {
      final nextFreeHintTime = currentHints.lastHintTime?.add(
        const Duration(hours: 3),
      );
      emit(state.copyWith(lastDiscoveredItem: 'need_wait_hint'));
    }
  }

  void _onClearActiveHint(
    ClearActiveHintEvent event,
    Emitter<LevelState> emit,
  ) {
    emit(
      state.copyWith(hintsState: state.hintsState.copyWith(currentHint: null)),
    );
  }

  void _onUseHint(UseHintEvent event, Emitter<LevelState> emit) {
    emit(
      state.copyWith(
        hintsState: state.hintsState.copyWith(hasPendingHint: false),
      ),
    );
  }

  // void _onBuyHints(BuyHintsEvent event, Emitter<LevelState> emit) {
  //   // В реальном приложении здесь была бы логика покупки
  //   emit(
  //     state.copyWith(
  //       hintsState: state.hintsState.copyWith(
  //         availableHints: state.hintsState.availableHints + event.amount,
  //       ),
  //     ),
  //   );
  // }

  // void _onMarkHintUsed(MarkHintUsedEvent event, Emitter<LevelState> emit) {
  //   if (state.hintsState.usedHints.contains(event.itemId)) {
  //     emit(
  //       state.copyWith(
  //         hintsState: state.hintsState.copyWith(
  //           usedHints:
  //               state.hintsState.usedHints
  //                   .where((id) => id != event.itemId)
  //                   .toList(),
  //         ),
  //       ),
  //     );
  //   }
  // }

  // // Вспомогательный метод для получения случайной подсказки
  // HintCombination? _getRandomHint(LevelState state) {
  //   // Получаем все возможные комбинации для доступных элементов
  //   final possibleCombinations = <HintCombination>[];

  //   for (final item1 in state.availableItems) {
  //     for (final item2 in state.availableItems) {
  //       if (item1 != item2) {
  //         final result = getMergeResult(item1, item2);
  //         if (result != null &&
  //             !state.hintsState.usedHints.contains(result) &&
  //             !state.discoveredItems.contains(result)) {
  //           possibleCombinations.add(HintCombination(item1, item2, result));
  //         }
  //       }
  //     }
  //   }

  //   if (possibleCombinations.isEmpty) return null;
  //   return possibleCombinations[Random().nextInt(possibleCombinations.length)];
  // }
}

class HintCombination {
  final String item1;
  final String item2;
  final String result;

  HintCombination(this.item1, this.item2, this.result);
}
