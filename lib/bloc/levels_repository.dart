// levels_repository.dart

class LevelsRepository {
  static final Map<int, Map<String, dynamic>> levelsData = {
    1: {
      'imageItems': ['water', 'man'],
      'result': 'cloud',
      'title': 'Создайте Облако',
      'hints': {
        1: ['water', 'water', 'cloud'],
        3: ['wind', 'wind', 'sky'],
      },
    },
    2: {
      'imageItems': ['water', 'fish', 'dnk', 'sugar'],
      'result': 'dolphin',
      'title': 'Создайте гриб',
      'hints': {
        1: ['water', 'cloud', 'sugar'],
        2: ['sugar', 'sugar', 'mushroom'],
      },
    },

    // Уровень 3: "Создайте город"
    3: {
      'imageItems': ['new_year', 'tree', 'village'],
      'result': 'city',
      'title': 'Создайте мегаполис',
      'hints': {
        1: ['stone', 'stone', 'stone_mountain'],
        2: ['tree', 'tree', 'forest'],
        3: ['man', 'man', 'crowd_of_people'],
        4: ['crowd_of_people', 'stone', 'village'],
        5: ['village', 'forest', 'wooden'],
        6: ['wooden', 'tool', 'house'],
        7: ['house', 'house', 'city'],
        8: ['city', 'car', 'metropolis'], // Секретное улучшение
      },
    },
    //Уровень 4: "Рождественское чудо"
    4: {
      'imageItems': ['tree', 'snow', 'man'],
      'result': 'santa_claus',
      'title': 'Вызовите Санту',
      'hints': {
        1: ['tree', 'snow', 'new_year_tree'],
        2: ['man', 'man', 'love'],
        3: ['love', 'new_year_tree', 'holiday'],
        4: ['holiday', 'snow', 'winter'],
        5: ['winter', 'man', 'cold'],
        6: ['cold', 'holiday', 'penguin'],
        7: ['penguin', 'winter', 'santa_claus'],
        8: ['santa_claus', 'new_year_tree', 'present'], // Секретный предмет
      },
    },
    //Уровень 5: "Индустриальная революция"
    5: {
      'imageItems': ['iron', 'fire', 'man'],
      'result': 'factory',
      'title': 'Постройте фабрику',
      'hints': {
        1: ['iron', 'fire', 'steel'],
        2: ['steel', 'stone', 'tool'],
        3: ['tool', 'wooden', 'wheel'],
        4: ['wheel', 'wheel', 'bicycle'],
        5: ['bicycle', 'steel', 'machine'],
        6: ['man', 'machine', 'worker'],
        7: ['worker', 'worker', 'factory'],
        8: ['factory', 'electricity', 'automation'], // Секретный апгрейд
      },
    },
    //Уровень 6: "Лабораторный эксперимент"
    6: {
      'imageItems': ['bacteria', 'radiation', 'tool'],
      'result': 'dna',
      'title': "Создайте ДНК",
      'hints': {
        1: ['bacteria', 'radiation', 'mutation'],
        2: ['mutation', 'water', 'plankton'],
        3: ['plankton', 'plankton', 'fish'],
        4: ['fish', 'mutation', 'lizard'],
        5: ['lizard', 'radiation', 'monster'],
        6: ['tool', 'monster', 'experiment'],
        7: ['experiment', 'bacteria', 'dna'],
        8: ['dna', 'man', 'clone'], // Секретный результат
      },
    },
    //Уровень 7: "Средневековье"
    7: {
      'imageItems': ['stone', 'man', 'tree'],
      'result': 'knight',
      'title': "Создайте рыцаря",
      'hints': {
        1: ['stone', 'stone', 'stone_mountain'],
        2: ['tree', 'tool', 'wooden'],
        3: ['wooden', 'stone', 'castle'],
        4: ['man', 'castle', 'king'],
        5: ['king', 'wooden', 'throne'],
        6: ['throne', 'man', 'power'],
        7: ['power', 'castle', 'knight'],
        8: ['knight', 'dragon', 'legend'], // Эпичный финал
      },
    },
    //Уровень 8: "Технологический прорыв"
    8: {
      'imageItems': ['sand', 'electricity', 'metal'],
      'result': 'phone',
      'title': "Изобретите смартфон",
      'hints': {
        1: ['sand', 'fire', 'glass'],
        2: ['glass', 'metal', 'mirror'],
        3: ['electricity', 'metal', 'wire'],
        4: ['wire', 'glass', 'lightbulb'],
        5: ['lightbulb', 'wire', 'signal'],
        6: ['signal', 'metal', 'radio'],
        7: ['radio', 'glass', 'phone'],
        8: ['phone', 'phone', 'smartphone'], // Модернизация
      },
    },
    //Уровень 9: "Экологическая катастрофа"
    9: {
      'imageItems': ['factory', 'car', 'tree'],
      'result': 'volcano',
      'title': "Разбудите вулкан",
      'hints': {
        1: ['factory', 'car', 'pollution'],
        2: ['tree', 'pollution', 'dead_tree'],
        3: ['dead_tree', 'dead_tree', 'desert'],
        4: ['factory', 'pollution', 'acid'],
        5: ['acid', 'stone', 'erosion'],
        6: ['erosion', 'stone_mountain', 'unstable'],
        7: ['unstable', 'acid', 'volcano'],
        8: ['volcano', 'city', 'panic'], // Дополнительный хаос
      },
    },
    // Уровень 10: "Магический ритуал"
    10: {
      'imageItems': ['book', 'love', 'mushroom'],
      'result': 'witch',
      'title': "Создайте ведьму",
      'hints': {
        1: ['book', 'love', 'poetry'],
        2: ['mushroom', 'mushroom', 'magic_mushroom'],
        3: ['poetry', 'magic_mushroom', 'spell'],
        4: ['spell', 'book', 'grimoire'],
        5: ['grimoire', 'woman', 'enchantress'],
        6: ['enchantress', 'spell', 'sorcery'],
        7: ['sorcery', 'love', 'witch'],
        8: ['witch', 'broom', 'flying'], // Секретное умение
      },
    },
    //Уровень 11: "Космическая гонка"
    11: {
      'imageItems': ['metal', 'electricity', 'intelligence'],
      'result': 'rocket',
      'title': "Запустите ракету",
      'hints': {
        1: ['metal', 'electricity', 'engine'],
        2: ['intelligence', 'engine', 'technology'],
        3: ['technology', 'metal', 'spaceship'],
        4: ['spaceship', 'electricity', 'systems'],
        5: ['systems', 'intelligence', 'ai'],
        6: ['ai', 'spaceship', 'control'],
        7: ['control', 'engine', 'rocket'],
        8: ['rocket', 'sky', 'moon'], // Следующая цель
      },
    },
    //Уровень 12: "Пиратское приключение"
    12: {
      'imageItems': ['wooden', 'sea', 'man'],
      'result': 'sailing_ship',
      'title': "Постройте парусник",
      'hints': {
        1: ['wooden', 'wooden', 'plank'],
        2: ['plank', 'tool', 'mast'],
        3: ['sea', 'wind', 'wave'],
        4: ['mast', 'wave', 'boat'],
        5: ['man', 'boat', 'sailor'],
        6: ['sailor', 'plank', 'deck'],
        7: ['deck', 'mast', 'sailing_ship'],
        8: ['sailing_ship', 'knight', 'pirate'], // Неожиданный поворот
      },
    },

    // Добавьте другие уровни по аналогии
  };
}
