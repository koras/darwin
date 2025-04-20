// levels_repository.dart

class LevelsRepository {
  static final Map<int, Map<String, dynamic>> levelsData = {
    1: {
      'imageItems': ['water'],
      'result': 'cloud',
      'title': 'Создайте море',
      'hints': {
        1: ['water', 'water', 'cloud'],
        2: ['cloud', 'cloud', 'wind'],
        3: ['wind', 'wind', 'sky'],
      },
    },
    2: {
      'imageItems': ['dnk', 'man', 'morning'],
      'result': 'wmushroom',
      'title': 'Создайте гриб',
      'hints': {
        1: ['water', 'cloud', 'sugar'],
        2: ['sugar', 'sugar', 'mushroom'],
      },
    },
    // Добавьте другие уровни по аналогии
  };
}
