// level_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

part 'level_event.dart';
part 'level_state.dart';

class LevelBloc extends Bloc<LevelEvent, LevelState> {
  // Здесь храним данные всех уровней
  final Map<int, Map<String, dynamic>> _levelsData = {
    1: {
      'imageItems': ['water', 'cloud', 'sky'],
      'result': 'wind',
      'title': 'Создайте ветер',
      'hints': {
        1: ['water', 'cloud', 'sugar'],
        2: ['sugar', 'sugar', 'mushroom'],
      },
    },
    // Добавьте другие уровни по аналогии
  };

  LevelBloc() : super(LevelState(
    currentLevel: 1,
    availableItems: ['water', 'cloud', 'sky'],
    targetItem: 'wind',
    levelTitle: 'Создайте ветер',
    hints: {
      1: ['water', 'cloud', 'sugar'],
      2: ['sugar', 'sugar', 'mushroom'],
    },
  )) {
    on<LoadLevelEvent>(_onLoadLevel);
    on<LevelCompletedEvent>(_onLevelCompleted);
  }

  void _onLoadLevel(LoadLevelEvent event, Emitter<LevelState> emit) {
    final levelData = _levelsData[event.levelId];
    if (levelData != null) {
      emit(LevelState(
        currentLevel: event.levelId,
        availableItems: List<String>.from(levelData['imageItems']),
        targetItem: levelData['result'],
        levelTitle: levelData['title'],
        hints: Map<int, List<String>>.from(levelData['hints']),
      );
    }
  }

  void _onLevelCompleted(LevelCompletedEvent event, Emitter<LevelState> emit) {
    // При завершении уровня можно загрузить следующий
    final nextLevel = state.currentLevel + 1;
    if (_levelsData.containsKey(nextLevel)) {
      add(LoadLevelEvent(nextLevel));
    }
  }
}