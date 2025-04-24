import '../models/merge_rule.dart';

final List<MergeRule> mergeRules = [
  // Базовые элементы природы
  MergeRule('water', 'water', 'cloud'),
  MergeRule('cloud', 'cloud', 'sky'),
  MergeRule('sky', 'sky', 'sun'),
  MergeRule('water', 'sun', 'rainbow'),
  MergeRule('water', 'earth', 'mud'),
  MergeRule('mud', 'water', 'swamp'),
  MergeRule('swamp', 'bacteria', 'life'),
  MergeRule('life', 'water', 'plankton'),

  // Животные и растения
  MergeRule('plankton', 'plankton', 'fish'),
  MergeRule('fish', 'fish', 'dolphin'),
  MergeRule('dolphin', 'earth', 'mammal'),
  MergeRule('mammal', 'tree', 'monkey'),
  MergeRule('monkey', 'time', 'man'),
  MergeRule('tree', 'tree', 'forest'),
  MergeRule('forest', 'man', 'wood'),

  // Технологии и инструменты
  MergeRule('wood', 'stone', 'tool'),
  MergeRule('tool', 'wood', 'wheel'),
  MergeRule('wheel', 'wheel', 'cart'),
  MergeRule('cart', 'tool', 'car'),
  MergeRule('car', 'car', 'traffic'),
  MergeRule('tool', 'iron', 'machine'),
  MergeRule('machine', 'wheel', 'factory'),

  // Городская среда
  MergeRule('house', 'house', 'village'),
  MergeRule('village', 'village', 'city'),
  MergeRule('city', 'city', 'metropolis'),
  MergeRule('metropolis', 'metropolis', 'megalopolis'),
  MergeRule('house', 'money', 'bank'),
  MergeRule('city', 'car', 'traffic_jam'),

  // Еда и напитки
  MergeRule('grape', 'sun', 'wine'),
  MergeRule('wine', 'man', 'alcohol'),
  MergeRule('alcohol', 'alcohol', 'hangover'),
  MergeRule('wheat', 'stone', 'flour'),
  MergeRule('flour', 'water', 'dough'),
  MergeRule('dough', 'fire', 'bread'),
  MergeRule('bread', 'sugar', 'cake'),

  // Праздники и культура
  MergeRule('man', 'woman', 'love'),
  MergeRule('love', 'love', 'family'),
  MergeRule('family', 'family', 'crowd_of_people'),
  MergeRule('crowd_of_people', 'music', 'party'),
  MergeRule('party', 'alcohol', 'holiday'),
  MergeRule('holiday', 'winter', 'new_year'),
  MergeRule('new_year', 'tree', 'new_year_tree'),

  // Наука и технологии
  MergeRule('sand', 'fire', 'glass'),
  MergeRule('glass', 'metal', 'mirror'),
  MergeRule('metal', 'fire', 'steel'),
  MergeRule('steel', 'tool', 'machine'),
  MergeRule('machine', 'electricity', 'robot'),
  MergeRule('robot', 'intelligence', 'ai'),

  // Мифология и фантастика
  MergeRule('lizard', 'fire', 'dragon'),
  MergeRule('dragon', 'man', 'knight'),
  MergeRule('knight', 'dragon', 'legend'),
  MergeRule('legend', 'book', 'history'),
  MergeRule('history', 'time', 'future'),

  // Погодные явления
  MergeRule('water', 'cold', 'ice'),
  MergeRule('ice', 'wind', 'blizzard'),
  MergeRule('blizzard', 'man', 'snowman'),
  MergeRule('cloud', 'cold', 'snow'),
  MergeRule('snow', 'man', 'snowman'),
  MergeRule('water', 'wind', 'wave'),

  // География
  MergeRule('water', 'earth', 'lake'),
  MergeRule('lake', 'lake', 'sea'),
  MergeRule('sea', 'sea', 'ocean'),
  MergeRule('earth', 'earth', 'hill'),
  MergeRule('hill', 'hill', 'mountain'),
  MergeRule('mountain', 'fire', 'volcano'),

  // Современные технологии
  MergeRule('metal', 'electricity', 'wire'),
  MergeRule('wire', 'glass', 'lightbulb'),
  MergeRule('lightbulb', 'man', 'idea'),
  MergeRule('idea', 'tool', 'invention'),
  MergeRule('invention', 'wire', 'phone'),
  MergeRule('phone', 'phone', 'smartphone'),
  MergeRule('smartphone', 'man', 'social_media'),
];
