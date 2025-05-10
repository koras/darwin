// level_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'levels_repository.dart';
import '../models/game_item.dart';

import 'package:hive/hive.dart';
part 'level_event.dart';
part 'level_state.dart';

class LevelBloc extends Bloc<LevelEvent, LevelState> {
  LevelBloc() : super(LevelState.initial()) {
    final firstLevelData = LevelsRepository.levelsData[1]!;

    // Загружаем первый уровень при инициализации
    emit(
      LevelState(
        currentLevel: 1,
        availableItems: List<String>.from(firstLevelData['imageItems']),
        discoveredItems: List<String>.from(firstLevelData['imageItems']),
        targetItem: firstLevelData['result'],
        levelTitle: firstLevelData['title'],
        hints: Map<int, List<String>>.from(firstLevelData['hints']),
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

    //  print('Результат после удаления: event.items  ${event.items}');

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
          hints: Map<int, List<String>>.from(levelData['hints']),
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
          hints: Map<int, List<String>>.from(levelData['hints']),
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
}
