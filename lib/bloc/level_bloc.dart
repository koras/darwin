// level_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'levels_repository.dart';

part 'level_event.dart';
part 'level_state.dart';

class LevelBloc extends Bloc<LevelEvent, LevelState> {
  LevelBloc() : super(LevelState.initial()) {
    final firstLevelData = LevelsRepository.levelsData[1]!;
    // Здесь храним данные всех уровней
    // final Map<int, Map<String, dynamic>> _levelsData = {
    //   1: {
    //     'imageItems': ['water'],
    //     'result': 'cloud',
    //     'title': 'Создайте море',
    //     'hints': {
    //       1: ['water', 'water', 'cloud'],
    //       2: ['cloud', 'cloud', 'wind'],
    //       3: ['wind', 'wind', 'sky'],
    //     },
    //   },
    //   2: {
    //     'imageItems': ['dnk', 'man', 'morning'],
    //     'result': 'wmushroom',
    //     'title': 'Создайте гриб',
    //     'hints': {
    //       1: ['water', 'cloud', 'sugar'],
    //       2: ['sugar', 'sugar', 'mushroom'],
    //     },
    //   },
    //   // Добавьте другие уровни по аналогии
    // };

    // Загружаем первый уровень при инициализации
    emit(
      LevelState(
        currentLevel: 1,
        availableItems: List<String>.from(firstLevelData['imageItems']),
        targetItem: firstLevelData['result'],
        levelTitle: firstLevelData['title'],
        hints: Map<int, List<String>>.from(firstLevelData['hints']),
      ),
    );

    on<LoadLevelEvent>(_onLoadLevel);
    on<LevelCompletedEvent>(_onLevelCompleted);
  }

  void _onLoadLevel(LoadLevelEvent event, Emitter<LevelState> emit) {
    print('Загрузка уровня ${event.levelId}');
    final levelData = LevelsRepository.levelsData[event.levelId];
    if (levelData != null) {
      emit(
        LevelState(
          currentLevel: event.levelId,
          availableItems: List<String>.from(levelData['imageItems']),
          targetItem: levelData['result'],
          levelTitle: levelData['title'],
          hints: Map<int, List<String>>.from(levelData['hints']),
        ),
      );
    } else {
      print('Уровень ${event.levelId} не найден');
    }
  }

  void _onLevelCompleted(LevelCompletedEvent event, Emitter<LevelState> emit) {
    print("При завершении уровня можно загрузить следующий");
    final nextLevel = state.currentLevel + 1;
    print('nextLevel $nextLevel');

    if (LevelsRepository.levelsData.containsKey(nextLevel)) {
      print('грузим');
      final levelData = LevelsRepository.levelsData[nextLevel]!;
      emit(
        LevelState(
          currentLevel: nextLevel,
          availableItems: List<String>.from(levelData['imageItems']),
          targetItem: levelData['result'],
          levelTitle: levelData['title'],
          hints: Map<int, List<String>>.from(levelData['hints']),
        ),
      );
    }
  }
}
