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
    ].map((id) => ImageItem(id)).toList();
