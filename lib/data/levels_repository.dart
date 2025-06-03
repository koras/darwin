// levels_repository.dart
import 'package:flutter/material.dart';
import 'package:darwin/gen_l10n/app_localizations.dart';

class LevelsRepository {
  static late AppLocalizations _l10n;

  static void initialize(BuildContext context) {
    _l10n = AppLocalizations.of(context)!;
  }

  static Map<int, Map<String, dynamic>> get levelsData {
    return {
      1: {
        // результат который должен получиться
        'result': 'cloud',
        // какие элементы даны первоначально
        'imageItems': ['water', 'wind'],

        // здесь подсказка, конечный результат соеденения и так же сюда добавляется вся цепочка для того чтобы достигнуть результата
        'hints': ['cloud'],
        // Какое задание получает игрок
        'title': 'Создай облако',
        // картинка, для фона на уровне
        'background': 'level2.png',
        // сколько бесплатных подсказок на уровне
        'freeHints': 3,
        // сколько ждать чтобы получить подсказку бесплатно
        'timeHintWait': 10,
        // описание
        'description': 'Используй стихии, чтобы создать небесный простор',

        'story': '',
      },
      2: {
        'result': 'rain',
        'imageItems': ['water', 'wind', 'water'],
        'hints': ['cloud', 'sky', 'monkey', 'man'],
        'title': 'Вызови дождь',
        'background': 'level7.png',
        'freeHints': 3, // сколько бесплатных подсказок на уровне
        'timeHintWait': 10, // сколько ждать чтобы получить подсказку бесплатно
        'description': 'Повтори природный цикл: испарение -> облака -> осадки',
        'story': 'Капли воды мечтают вернуться на землю. Помоги им!',
      },

      // Уровень 3: "Создайте город"
      3: {
        'result': 'rainbow',
        'imageItems': ['water', 'wind', 'fire', 'water'],
        'hints': ['fire', 'water'],
        'title': 'Создай радугу',
        'background': 'level3.png',
        'freeHints': 3, // сколько бесплатных подсказок на уровне
        'timeHintWait': 10,
        'description': 'Тебе понадобятся дождь и солнечный свет',
        'story':
            'После дождя на небе появляется волшебство. Сможешь его повторить?',
      },
      4: {
        'result': 'mountain',
        'imageItems': ['earth', 'earth', 'water'],
        'hints': ['earth', 'water'],
        'title': 'Построй гору',
        'description': 'Соедини элементы земли, затем добавь воду',
        'story':
            'Давным-давно тектонические плиты создали величественные горы...',
        'background': 'level2.png',
        'freeHints': 3, // сколько бесплатных подсказок на уровне
        'timeHintWait': 10,
      },
      5: {
        'result': 'fish',
        'imageItems': ['earth', 'water', 'water', 'time'],
        'hints': ['time'],
        'title': 'Создай первую рыбу',
        'description': 'Начни с бактерий и дай им время развиться',
        'story': 'Жизнь зародилась в океане... Проследи эволюцию!',
      },
      6: {
        'result': 'storm',
        'imageItems': ['water', 'wind', 'wind', 'water', 'cloud'],
        'hints': ['wind', 'cloud'],
        'title': 'Вызови бурю',
        'description': 'Тебе понадобятся облака и электричество',
        'story': 'Небо темнеет... Чувствуешь напряжение в воздухе?',
      },
      7: {
        'result': 'tool',
        'imageItems': ['earth', 'fire', 'water', 'earth', 'man'],
        'hints': ['fire', 'man'],
        'title': 'Изобрети первый инструмент',
        'description': 'Человеку нужен камень и огонь, чтобы начать прогресс',
        'story': 'Первый шаг к цивилизации...',
      },
      8: {
        'result': 'forest',
        'imageItems': ['earth', 'water', 'wind', 'fire', 'time', 'earth'],
        'hints': ['time', 'wind'],
        'title': 'Вырасти лес',
        'description': 'Начни с болота, добавь время и стихии',
        'story': 'Даже магия начинается с маленького ростка...',
      },
      9: {
        'result': 'lightning',
        'imageItems': ['fire', 'wind', 'cloud', 'wind'],
        'hints': ['fire', 'wind'],
        'title': 'Приручи молнию',
        'description': 'Огонь и ветер могут создать нечто мощное...',
        'story': 'Зевс не одобряет, но мы попробуем!',
      },
      10: {
        'result': 'wine',
        'imageItems': ['earth', 'water', 'time', 'grape'],
        'hints': ['time', 'grape'],
        'title': 'Приготовь вино',
        'description': 'Ферментация требует терпения...',
        'story': 'Древние греки знали толк в этом искусстве!',
      },
      11: {
        'result': 'dragon',
        'imageItems': ['fire', 'earth', 'lizard', 'swamp', 'time'],
        'hints': ['lizard', 'time'],
        'title': 'Создай дракона',
        'description': 'Рептилия + магия стихий = легенда',
        'story': 'Мифы становятся реальностью...',
      },
      12: {
        'result': 'city',
        'imageItems': ['earth', 'fire', 'man', 'wood', 'stone', 'tool'],
        'hints': ['man', 'tool'],
        'title': 'Основать город',
        'description': 'Начни с инструментов и объедини людей',
        'story': 'От хижины к метрополису...',
      },
      13: {
        'result': 'spaceship',
        'imageItems': [
          'metal',
          'fire',
          'wind',
          'electricity',
          'computer',
          'satellite',
        ],
        'hints': ['electricity', 'computer'],
        'title': 'Запусти ракету',
        'description': 'От пара до искусственного интеллекта...',
        'story': 'Мечта Циолковского становится реальностью!',
      },
      14: {
        'result':
            'hero', // Можно получить через knight + dragon ИЛИ scientist + book
        'imageItems': ['man', 'sword', 'dragon', 'book'],
        'hints': ['sword', 'book'],
        'title': 'Стань героем',
        'description': 'Сила или знание? Выбери путь!',
      },
    };
  }
}
