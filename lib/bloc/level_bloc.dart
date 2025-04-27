// level_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'levels_repository.dart';

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

  void _onItemDiscovered(ItemDiscoveredEvent event, Emitter<LevelState> emit) {
    if (state.discoveredItems.contains(event.itemId)) return;

    final newDiscovered = [...state.discoveredItems, event.itemId];
    final newAvailable = [...state.availableItems, event.itemId];

    emit(
      state.copyWith(
        discoveredItems: newDiscovered,
        availableItems: newAvailable,
      ),
    );
  }

  void _onLevelCompleted(LevelCompletedEvent event, Emitter<LevelState> emit) {
    final nextLevel = state.currentLevel + 1;

    if (LevelsRepository.levelsData.containsKey(nextLevel)) {
      final levelData = LevelsRepository.levelsData[nextLevel]!;
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
    }
  }
}
