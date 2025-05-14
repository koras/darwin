// levels_repository.dart

class LevelsRepository {
  static final Map<int, Map<String, dynamic>> levelsData = {
    1: {
      'imageItems': ['water', 'mammal', 'tree', 'time'],
      'result': 'sun',
      'title': 'Создайте sun',
      'hints': [
        'cloud',
        'sky',
        'monkey',
        'man',
        'enchantress',
        'sorcery',
        'witch',
        'flying',
      ],
    },
    2: {
      'imageItems': ['water', 'cloud', 'fish', 'dnk', 'sugar'],
      'result': 'dolphin',
      'title': 'Создайте гриб',
      'hints': ['cloud', 'sky', 'grimoire', 'enchantress'],
    },

    // Уровень 3: "Создайте город"
    3: {
      'imageItems': ['new_year', 'tree', 'village'],
      'result': 'city',
      'title': 'Создайте мегаполис',
      'hints': [
        'cloud',
        'sky',
        'grimoire',
        'enchantress',
        'sorcery',
        'witch',
        'flying',
      ], // Секретное улучшение
    },
    //Уровень 4: "Рождественское чудо"
    4: {
      'imageItems': ['tree', 'snow', 'man'],
      'result': 'santa_claus',
      'title': 'Вызовите Санту',
      'hints': [
        'cloud',
        'sky',
        'grimoire',
        'enchantress',
        'sorcery',
        'witch',
        'flying',
      ],
    },
    //Уровень 5: "Индустриальная революция"
    5: {
      'imageItems': ['iron', 'fire', 'man'],
      'result': 'factory',
      'title': 'Постройте фабрику',
      'hints': [
        'cloud',
        'sky',
        'grimoire',
        'enchantress',
        'sorcery',
        'witch',
        'flying',
      ],
    },

    // Добавьте другие уровни по аналогии
  };
}
