import 'package:flutter/material.dart';
// level_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:darwin/data/levels_repository.dart';
import 'package:darwin/models/game_item.dart';
import 'package:darwin/services/hive_service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:hive/hive.dart';
part 'level_event.dart';
part 'level_state.dart';
part 'level_bloc.g.dart'; // Добавлено для генерации

class LevelBloc extends Bloc<LevelEvent, LevelState> {
  LevelBloc() : super(LevelState.initial()) {
    // Загружаем сохраненный уровень
    // final savedLevel = HiveService.loadLevel();

    // Загружаем данные уровня
    // final levelData =
    //     LevelsRepository.levelsData[savedLevel] ??
    //     LevelsRepository.levelsData[1]!;

    //  final firstLevelData = LevelsRepository.levelsData[1]!;

    // Загружаем первый уровень при инициализации
    // emit(
    //   LevelState(
    //     currentLevel: savedLevel,
    //     availableItems: List<String>.from(levelData['imageItems']),
    //     discoveredItems: List<String>.from(levelData['imageItems']),
    //     targetItem: levelData['result'],
    //     levelTitle: levelData['title'],
    //     hints: List<String>.from(levelData['hints']),
    //   ),
    // );

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

  String _getLocalizedString(AppLocalizations l10n, String key) {
    return 'asdfasdf';
    try {
      return (l10n as dynamic)[key] as String? ?? key;
    } catch (e) {
      return key; // Fallback
    }
  }

  void _onLoadLevel(LoadLevelEvent event, Emitter<LevelState> emit) {
    print('Загрузка уровня ${event.levelId}');

    //  final levelData = LevelsRepository.levelsData[event.levelId];

    print('event.levelId ${event.levelId}');
    //if (event.levelId != null) {
    //     final keyTitle = levelData['title'];
    //   final l10n = AppLocalizations.of(event.context)!.keyTitle;
    //   print('1111keyTitle ${keyTitle}');
    //  final l10n = AppLocalizations.of(event.context)!;
    // Получаем локализованный заголовок

    //  final localizedTitle = _getLocalizedString(l10n, keyTitle);
    //   AppLocalizations.of(event.context)!.title_compatibility
    // Сохраняем уже открытые предметы
    final currentDiscovered = state.discoveredItems;
    // Начальные предметы уровня + уже открытые

    //    print('keyTitle ${localizedTitle}');
    // AppLocalizations.of(context)!.yourStringKey
    final allAvailable =
        [
          ...List<String>.from(event.imageItems),
          ...currentDiscovered,
        ].toSet().toList(); // Убираем дубликаты

    emit(
      LevelState(
        currentLevel: event.levelId,
        availableItems: allAvailable,
        discoveredItems: currentDiscovered,
        targetItem: event.result,
        //  levelTitle: l10n.level1Title,
        levelTitle: event.title,
        hints: event.hints,
        background: event.background,
      ),
    );
  }

  void _onClearDiscovery(ClearDiscoveryEvent event, Emitter<LevelState> emit) {
    emit(state.copyWith(lastDiscoveredItem: null));
  }

  // все новые предметы здесь
  void _onItemDiscovered(ItemDiscoveredEvent event, Emitter<LevelState> emit) {
    print('${state.hintsState.currentHint} state.hintsState.currentHint ');
    print('${event.itemId} event.itemId');

    if (state.discoveredItems.contains(event.itemId)) return;

    // Проверяем, был ли предмет ранее доступен
    final isNew = !state.availableItems.contains(event.itemId);

    final newDiscovered = [...state.discoveredItems, event.itemId];
    final newAvailable = [...state.availableItems, event.itemId];

    emit(
      state.copyWith(
        //   hintsState: state.hintsState.copyWith(hasPendingHint: false,currentHint: currentHint:''),
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

  void _onDecrementHint(DecrementHint event, Emitter<LevelState> emit) {
    print('проверяем, есть ли у нас подсказки');

    if (state.hintsState.freeHints > 0) {
      print('--- убавляем freeHints ${state.hintsState.freeHints}');
      // сперва если есть бесплатные, мы вычитаем именно бесплатные

      emit(
        state.copyWith(
          hintsState: state.hintsState.copyWith(
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
            paidHintsAvailable: state.hintsState.paidHintsAvailable - 1,
            countHintsAvailable:
                state.hintsState.freeHints +
                state.hintsState.paidHintsAvailable -
                1,
          ),
        ),
      );
      return;
    }
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
    print(' подсказка ${event.currentHint} ');
    emit(
      state.copyWith(
        hintsState: state.hintsState.copyWith(currentHint: event.currentHint),
      ),
    );
  }

  void _onUseHint(UseHintEvent event, Emitter<LevelState> emit) {
    emit(
      state.copyWith(
        hintsState: state.hintsState.copyWith(
          hasPendingHint: false,
          currentHint: '',
        ),
      ),
    );
  }

  void _onSetHint(SetHintEvent event, Emitter<LevelState> emit) {
    emit(
      state.copyWith(
        hintsState: state.hintsState.copyWith(hasPendingHint: true),
      ),
    );
  }
}

class HintCombination {
  final String item1;
  final String item2;
  final String result;

  HintCombination(this.item1, this.item2, this.result);
}
