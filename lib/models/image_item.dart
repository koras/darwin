import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class ImageItem {
  final String id;
  // final String slug;
  // final String assetPath;
  Offset position;
  //ImageItem(this.id, this.slug, this.assetPath, {this.position = Offset.zero});

  ImageItem(this.id, {this.position = Offset.zero});
  // Вычисляемые свойства
  String get slug => id; // slug совпадает с id
  String get assetPath =>
      'assets/images/$id.png'; // Генерируем путь автоматически
}

final List<ImageItem> allImages =
    [
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
      'ballerina_cappuccino',
      'bombardiro_crocodilo',
      'lirili_larila',
      'tralalero_tralala',
      'shark_and_nike',
      'Hogwarts_School_of_Witchcraft_and_Wizardry',
      'March_8',
      'New_Year`s_star',
      'Thor_man',
      'ancient_bird',
      'ancient_marine_mammal',
      'ancient_sea_fish',
      'ancient_stone_age_man_with_stone',
      'archangel_with_wings_and_a_sword',
      'arya_stark_from_game_of_thrones',
      'bear_on_bicycle_in_circus',
      'bee',
      'bone_dragon',
      'burger',
      'candle',
      'church',
      'cipollino',
      'circus',
      'circus_clown',
      'corsair_pirate_sea',
      'daenerys targaryen',
      'fire_elemental',
      'firefighter',
      'fireworks',
      'fruits',
      'gandalf_from_the_lord_of_the_rings',
      'girl_in_love',
      'grandmother',
      'guy_in_love',
      'hobbit_from_lord_of_the_rings',
      'holiday_people',
      'honeycombs',
      'house_in_the_village',
      'institute_education',
      'jon_snow_from game_of_thrones',
      'lamb',
      'magic_broom',
      'magician_illusionist',
      'male_scientist',
      'masks_from_the_theater',
      'mermaid',
      'microbes',
      'modern_sea_deck_of_ship',
      'modern_tool',
      'multicolored_balloons',
      'old_sea_deck_of_ship',
      'people',
      'pirate_ship',
      'plank_stack_folded',
      'prometheus_who_gave_fire',
      'rooster',
      'rope',
      'sea ​_sailing_ship',
      'spider_man',
      'spider_web',
      'stone_elemental',
      'strong_man',
      'student_guy',
      'students',
      'sword',
      'the_plane_is_flying',
      'the_witcher_man_from_the_game',
      'theater_of_masks_play',
      'thor_s_hammer',
      'time_machine',
      'traveler',
      'two_students',
      'underground_metro',
      'whale',
      'wind',
      'young_girl',
      'young_guy',

      'Frost',
      'Phoenix',
      'Sand',
      'Thunderstorm_with_lightning',
      'Tornado',
      'Unicorn',
      'Vampire',
      'Zombie',
      'geyser',
    ].map((id) => ImageItem(id)).toList();
