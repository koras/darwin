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
        'background': 'level2.png',
      },
      2: {
        'imageItems': [
          'time',
          'water', // Вода
          'cloud', // Облако
          'dna', // ДНК
          'man', // Человек (мужчина)
          'morning', // Утро
          'mushroom', // Гриб
          'sky', // Небо
          'sugar', // Сахар
          'wind', // Ветер
          'explosion', // Взрыв
          'radiation', // Радиация
          'grape', // Виноград
          'holiday', // Праздник
          'knight', // Рыцарь
          'plane', // Самолёт
          'phone', // Телефон
          'car', // Автомобиль
          'barista', // Бариста
          'phone_old', // Старинный телефон
          'wooden', // Деревянный предмет
          'plankton', // Планктон
          'spider', // Паук
          'glacier', // Ледник
          'bacteria', // Бактерии
          'fish', // Рыба
          'tool', // Инструмент
          'bicycle', // Велосипед
          'wheel', // Колесо
          'crowd_of_people', // Толпа людей
          'alcohol', // Алкоголь
          'stone', // Камень
          'lizard', // Ящерица
          'tree', // Дерево
          'swamp', // Болото
          'flour', // Мука
          'bread', // Хлеб
          'banana', // Банан
          'factory', // Фабрика
          'volcano', // Вулкан
          'city', // Город
          'hungover_saturday_morning', // Похмельное субботнее утро
          'cake', // Торт
          'sailing_ship', // Парусник
          'sand_mountain', // Песчаная гора/дюна
          'stone_mountain', // Каменная гора
          'metropolis', // Мегаполис
          'village', // Деревня
          'snowman', // Снеговик
          'love', // Любовь
          'sea', // Море
          'bacterium', // Бактерия (единственное число)
          'monkey', // Обезьяна
          'money', // Деньги
          'santa_claus', // Санта-Клаус
          'new_year_tree', // Новогодняя ёлка
          'penguin', // Пингвин
          'witch', // Ведьма
          'big_crowd_of_people', // Большая толпа людей
          'noisy_friday_party', // Шумная пятничная вечеринка
          'dragon', // Дракон
          'book', // Книга
          'cow', // Корова
          'cocktail', // Коктейль
          'cupid', // Амур/Купидон
          'frog', // Лягушка
          'king_of_the_hill', // Король горы
          'monument', // Памятник
          'sommelier', // Сомелье
          'snow', // Снег
          'electricity', // Электричество
          'iron', // Железо
          'acid', // Кислота
          'milk', // Молоко
          'rocket', // Ракета
          'intelligence', // Интеллект
          'wood', // Древесина
          'wine', // Вино
          'sun', // Солнце
          'spark', // Искра
          'robot', // Робот
          'rainbow', // Радуга
          'metal', // Металл
          'mammal', // Млекопитающее
          'light', // Свет
          'life', // Жизнь
          'fire', // Огонь
          'earth', // Земля
          'dough', // Тесто
          'dolphin', // Дельфин
          'cat', // Кошка
          'dog', // Собака
          'artificial_intelligence', // Искусственный интеллект
          'train', // Поезд
          'mountain', // Гора
          'family', // Гора
          'leon', // Гора
          // мемные животные
          'daenerys_targaryen', //daenerys_targaryen
          'ballerina_cappuccino', // Балерина_капучино
          'bombardiro_crocodilo', // Бомбардир_крокодил
          'lirili_larila', // Лирили_ларила
          'tralalero_tralala', // Тралалеро_тралала
          'shark_and_nike', // Акула_и_найк
          'hogwarts_school', // Школа_Хогвартс_волшебства_и_магии
          'march_8', // 8_марта
          'new_years_star', // Новогодняя_звезда
          'thor_man', // Тор_человек
          'ancient_bird', // Древняя_птица
          'ancient_marine_mammal', // Древнее_морское_млекопитающее
          'ancient_sea_fish', // Древняя_морская_рыба
          'ancient_stone_age_man_with_stone', // Древний_человек_каменного_века_с_камнем
          'archangel_with_wings_and_a_sword', // Архангел_с_крыльями_и_мечом
          'arya_stark_from_game_of_thrones', // Арья_Старк_из_игры_престолов
          'bear_on_bicycle_in_circus', // Медведь_на_велосипеде_в_цирке
          'bee', // Пчела
          'bone_dragon', // Костяной_дракон
          'burger', // Бургер
          'candle', // Свеча
          'church', // Церковь
          'cipollino', // Чиполлино
          'circus', // Цирк
          'circus_clown', // Цирковой_клоун
          'corsair_pirate_sea', // Корсар_пират_море

          'fire_elemental', // Огненный_элементаль
          'firefighter', // Пожарный
          'fireworks', // Фейерверк
          'fruits', // Фрукты
          'gandalf_from_the_lord_of_the_rings', // Гэндальф_из_властелина_колец
          'girl_in_love', // Девушка_влюбленная
          'grandmother', // Бабушка
          'guy_in_love', // Парень_влюбленный
          'hobbit_from_lord_of_the_rings', // Хоббит_из_властелина_колец
          'holiday_people', // Праздничные_люди
          'honeycombs', // Соты
          'house_in_the_village', // Дом_в_деревне
          'institute_education', // Институт_образование
          'jon_snow_from_game_of_thrones', // Джон_Сноу_из_игры_престолов
          'lamb', // Ягненок
          'magic_broom', // Волшебная_метла
          'magician_illusionist', // Фокусник_иллюзионист
          'male_scientist', // Ученый_мужчина
          'masks_from_the_theater', // Маски_из_театра
          'mermaid', // Русалка
          'microbes', // Микробы
          'modern_sea_deck_of_ship', // Современная_морская_палуба_корабля
          'modern_tool', // Современный_инструмент
          'multicolored_balloons', // Разноцветные_воздушные_шары
          'old_sea_deck_of_ship', // Старая_морская_палуба_корабля
          'people', // Люди
          'pirate_ship', // Пиратский_корабль
          'plank_stack_folded', // Сложенные_доски
          'prometheus_who_gave_fire', // Прометей_подаривший_огонь
          'rooster', // Петух
          'rope', // Веревка
          'sea_sailing_ship', // Морской_парусный_корабль
          'spider_man', // Человек_паук
          'spider_web', // Паутина
          'stone_elemental', // Каменный_элементаль
          'strong_man', // Сильный_мужчина
          'student_guy', // Студент_парень
          'students', // Студенты
          'sword', // Меч
          'the_plane_is_flying', // Самолет_летит
          'the_witcher_man_from_the_game', // Ведьмак_из_игры
          'theater_of_masks_play', // Театр_масок_игра
          'thor_s_hammer', // Молот_Тора
          'time_machine', // Машина_времени
          'traveler', // Путешественник
          'two_students', // Два_студента
          'underground_metro', // Подземное_метро
          'whale', // Кит
          'wind', // Ветер
          'young_girl', // Молодая_девушка
          'young_guy', // Молодой_парень
          'frost', // Мороз
          'phoenix', // Феникс
          'sand', // Песок
          'thunderstorm_with_lightning', // Гроза_с_молнией
          'tornado', // Торнадо
          'unicorn', // Единорог
          'vampire', // Вампир
          'geyser', // Гейзер
          'antibiotic', // Антибиотик
          'electric_battery', // Электрическая батарея
          'frost', // Мороз/Иней
          'molotov_cocktail', // Коктейль Молотова
          'phoenix', // Феникс (мифологическая птица)
          'puss_in_boots', // Кот в сапогах (персонаж сказки)
          'sand', // Песок
          'schrodingers_cat', // Кот Шрёдингера (квантовый парадокс)
          'beehive', // Пчелиный улей
          'bitcoin', // Биткоин (криптовалюта)
          'cheese', // Сыр
          'chocolate', // Шоколад
          'geyser', // Гейзер (источник горячей воды)
          'pandemic', // Пандемия (глобальная эпидемия)
          'shrek', // Шрек (мультперсонаж)
          'zombie', // Зомби

          'death_star',
          'jedi_from_stars_wars',
          'yoda_is_a_wise_jedi',

          'crossopterygian_fish',
          'flower',
        ],
        'result': 'dolphin',
        'title': 'Создайте дракона',
        'hints': ['sky', 'grimoire', 'enchantress'],
        'background': 'level7.png',
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
