// levels_repository.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Основной импорт

import 'package:darwin/bloc/level_bloc.dart';
import 'package:darwin/services/hive_service.dart';
import 'package:darwin/screens/mergeGame.dart';

class LevelsRepository {
  static late AppLocalizations _l10n;

  static void initialize(BuildContext context) {
    _l10n = AppLocalizations.of(context)!;
  }

  static Map<int, Map<String, dynamic>> get levelsData {
    return {
      1: {
        'imageItems': ['water', 'mammal', 'tree', 'time'],
        'result': 'cloud',
        'title': _l10n.create_sun,
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
        'background': 'level1.png',
      },
      2: {
        'imageItems': ['water', 'cloud', 'fish', 'dnk', 'sugar'],
        'result': 'dolphin',
        'title': 'Создайте гриб',
        'hints': ['cloud', 'sky', 'grimoire', 'enchantress'],
        'background': 'level2.png',
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
        ],
        'background': 'level3.png', // Секретное улучшение
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
      },
    };
  }
}
