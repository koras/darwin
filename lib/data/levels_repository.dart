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
        // результат который должен получиться, в данном случае небо
        'result': 'sky',
        // какие элементы даны первоначально
        // от сюда игрок может взять элемент много раз и добавить на игровое поле
        // например добавить на игровое поле 4 water для того чтобы соеденить  их между собой
        'imageItems': ['water', 'wind'],
        // здесь подсказка, конечный результат соеденения и так же сюда добавляется вся цепочка для того чтобы достигнуть результата
        'hints': [
          // цепочка уровня, элемент из соеденения
          // 'water' + 'wind' = 'cloud'
          'cloud',
          // 'cloud' + 'cloud' = 'sky'
          // конечный результат, элемент из соеденения
          'sky',
        ],
        // Какое задание получает игрок
        'title': 'Создай облако',
        // картинка, для фона на уровне
        'background': 'level2.png',
        // сколько бесплатных подсказок на уровне
        'freeHints': 2,
        // сколько ждать чтобы получить следующую подсказку в секундах
        'timeHintWait': 10,
        // описание
        'description': 'Используй стихии, чтобы создать небесный простор',
        // какая то история
        'story': '',
      },
      2: {
        'result': 'rainbow',
        'imageItems': ['water', 'wind', 'fire'],
        'hints': ['cloud', 'rain', 'rainbow'],
        'title': 'Создай радугу',
        'background': 'level_rainbow.png',
        'freeHints': 2,
        'timeHintWait': 15,
        'description':
            'Используй природные явления, чтобы создать разноцветное чудо',
        'story': 'После дождя всегда появляется возможность для чуда!',
      },

      // Земля + Вода = Пшеница → Пшеница + Камень = Мука → Мука + Вода = Тесто → Тесто + Огонь = Хлеб
      3: {
        'result': 'bread',
        'imageItems': ['earth', 'water', 'stone', 'fire'],
        'hints': ['wheat', 'flour', 'dough', 'bread'],
        'title': 'Испеки хлеб',
        'background': 'level_farm.png',
        'freeHints': 1,
        'timeHintWait': 30,
        'description': 'Повтори путь от зерна до ароматной буханки',
        'story': 'Хлеб — всему голова! Научись создавать его с нуля.',
      },
      4: {
        'result': 'computer',
        'imageItems': ['sand', 'fire', 'metal', 'electricity', 'glass'],
        'hints': [
          'silicon',
          'chip',
          'circuit',
          'processor',
          'monitor',
          'computer',
        ],
        'title': 'Собери компьютер',
        'background': 'level_tech.png',
        'freeHints': 0,
        'timeHintWait': 45,
        'description':
            'От песка до искусственного интеллекта — путь технологий',
        'story': 'Знаешь ли ты, что твой смартфон начинался с горстки песка?',
      },
      5: {
        'result': 'honey',
        'imageItems': ['earth', 'water', 'sun', 'wind'],
        'hints': ['flower', 'bee', 'honey'],
        'title': 'Добыча мёда',
        'background': 'level_garden.png',
        'freeHints': 3,
        'timeHintWait': 20,
        'description': 'Помоги пчёлам создать сладкое золото',
        'story': 'Для одной ложки мёда пчела пролетает вокруг Земли дважды!',
      },
      // Металл + Огонь = Сталь → Сталь + Электричество = Двигатель → Двигатель + Огонь = Ракета → Песок + Огонь = Стекло → Стекло + Металл = Спутник → Ракета + Спутник = Космический корабль
      6: {
        'result': 'spaceship',
        'imageItems': ['metal', 'fire', 'electricity', 'wind', 'sand'],
        'hints': ['steel', 'engine', 'rocket', 'satellite', 'spaceship'],
        'title': 'Космическая программа',
        'background': 'level_space.png',
        'freeHints': 1,
        'timeHintWait': 60,
        'description': 'От куска металла до межзвёздного корабля',
        'story': 'Человечество всегда мечтало о звёздах...',
      },
    };
  }
}
