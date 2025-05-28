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
        //   'result': 'monkey',
        'result': 'sky',
        'imageItems': ['water', 'mammal', 'tree', 'tree', 'time'],
        'hints': ['cloud', 'sky', 'monkey', 'man'],
        'title': _l10n.create_sun,
        'background': 'level2.png', // количество подсказок на уровне
        'freeHints': 3, // сколько бесплатных подсказок на уровне
        'timeHintWait': 10, // сколько ждать чтобы получить подсказку бесплатно
      },
      2: {
        'result': 'sky',
        'imageItems': ['water'],
        'hints': ['cloud', 'sky', 'monkey', 'man'],
        'title': _l10n.create_sun,
        'background': 'level7.png',
        'freeHints': 3, // сколько бесплатных подсказок на уровне
        'timeHintWait': 10, // сколько ждать чтобы получить подсказку бесплатно
      },

      // Уровень 3: "Создайте город"
      3: {
        'result': 'monkey',
        'imageItems': ['water', 'mammal', 'tree', 'tree', 'time'],
        'hints': ['cloud', 'sky', 'monkey', 'man'],
        'title': _l10n.create_sun,
        'background': 'level3.png',
        'freeHints': 3, // сколько бесплатных подсказок на уровне
        'timeHintWait':
            10, // сколько ждать чтобы получить подсказку бесплатно // Секретное улучшение
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
        'background': 'level4.png',
        'freeHints': 1, // сколько бесплатных подсказок на уровне
        'timeHintWait': 10, // сколько ждать чтобы получить подсказку бесплатно
      },
    };
  }
}
