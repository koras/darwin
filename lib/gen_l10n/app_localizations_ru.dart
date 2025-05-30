// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get sound => 'Звук';

  @override
  String get testNotification => 'Тестовое уведомление';

  @override
  String get testNotificationSent => 'Тестовое уведомление отправлено!';

  @override
  String get backToMenu => 'Вернуться в меню';

  @override
  String get level_task => 'Задание уровня';

  @override
  String get new_level_element_title => 'Поздравляю!';

  @override
  String get new_level_element_text => 'Вы перешли на следующий уровень:';

  @override
  String get new_level_element_button_text => 'Следующий уровень';

  @override
  String get merge_all_title => 'Все комбинации';

  @override
  String get merge_all_title_you => 'Открытые вами комбинации:';

  @override
  String get merge_all_title_all => 'Все возможные комбинации:';

  @override
  String get merge_element => 'Элемент';

  @override
  String get merge_result => 'Результат';

  @override
  String hints_left(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Осталось подсказок',
      many: 'Осталось подсказок',
      few: 'Осталось подсказки',
      one: 'Осталась подсказка',
    );
    return '$_temp0';
  }

  @override
  String get hints_cost => '₽';

  @override
  String get run_out_of_hints => 'У вас закончились подсказки';

  @override
  String get hints_hints => 'Подсказка';

  @override
  String get hints_good => 'Понятно';

  @override
  String get combinationsTitle => 'Все комбинации';

  @override
  String get discoveredCombinations => 'Открытые вами комбинации:';

  @override
  String get allCombinations => 'Все возможные комбинации:';

  @override
  String get continueWithoutHints => 'Продолжить без подсказок';

  @override
  String get task_level => 'Задание';

  @override
  String get new_item => 'Новый предмет';

  @override
  String get hint_until_next_free => 'До следующей бесплатной подсказки';

  @override
  String get or_buy_a_hint => 'или купите подсказку';

  @override
  String get statistics => 'Статистика';

  @override
  String get time => 'Время';

  @override
  String get water => 'Вода';

  @override
  String get cloud => 'Облако';

  @override
  String get dna => 'ДНК';

  @override
  String get man => 'Человек';

  @override
  String get morning => 'Утро';

  @override
  String get mushroom => 'Гриб';

  @override
  String get sky => 'Небо';

  @override
  String get sugar => 'Сахар';

  @override
  String get wind => 'Ветер';

  @override
  String get explosion => 'Взрыв';

  @override
  String get radiation => 'Радиация';

  @override
  String get grape => 'Виноград';

  @override
  String get holiday => 'Праздник';

  @override
  String get knight => 'Рыцарь';

  @override
  String get plane => 'Самолёт';

  @override
  String get phone => 'Телефон';

  @override
  String get car => 'Автомобиль';

  @override
  String get barista => 'Бариста';

  @override
  String get phone_old => 'Старинный телефон';

  @override
  String get wooden => 'Деревянный предмет';

  @override
  String get plankton => 'Планктон';

  @override
  String get spider => 'Паук';

  @override
  String get glacier => 'Ледник';

  @override
  String get bacteria => 'Бактерии';

  @override
  String get fish => 'Рыба';

  @override
  String get tool => 'Инструмент';

  @override
  String get bicycle => 'Велосипед';

  @override
  String get wheel => 'Колесо';

  @override
  String get crowd_of_people => 'Толпа людей';

  @override
  String get alcohol => 'Алкоголь';

  @override
  String get stone => 'Камень';

  @override
  String get lizard => 'Ящерица';

  @override
  String get tree => 'Дерево';

  @override
  String get swamp => 'Болото';

  @override
  String get flour => 'Мука';

  @override
  String get bread => 'Хлеб';

  @override
  String get banana => 'Банан';

  @override
  String get factory => 'Фабрика';

  @override
  String get volcano => 'Вулкан';

  @override
  String get city => 'Город';

  @override
  String get hungover_saturday_morning => 'Похмельное утро';

  @override
  String get cake => 'Торт';

  @override
  String get sailing_ship => 'Парусник';

  @override
  String get sand_mountain => 'Песчаная гора';

  @override
  String get stone_mountain => 'Каменная гора';

  @override
  String get metropolis => 'Мегаполис';

  @override
  String get village => 'Деревня';

  @override
  String get snowman => 'Снеговик';

  @override
  String get love => 'Любовь';

  @override
  String get sea => 'Море';

  @override
  String get bacterium => 'Бактерия';

  @override
  String get monkey => 'Обезьяна';

  @override
  String get money => 'Деньги';

  @override
  String get santa_claus => 'Санта-Клаус';

  @override
  String get new_year_tree => 'Новогодняя ёлка';

  @override
  String get penguin => 'Пингвин';

  @override
  String get witch => 'Ведьма';

  @override
  String get big_crowd_of_people => 'Толпа людей';

  @override
  String get noisy_friday_party => 'Пятничная вечеринка';

  @override
  String get dragon => 'Дракон';

  @override
  String get book => 'Книга';

  @override
  String get cow => 'Корова';

  @override
  String get cocktail => 'Коктейль';

  @override
  String get cupid => 'Амур/Купидон';

  @override
  String get arya_stark_from_game_of_thrones => 'Ария Старк';

  @override
  String get jon_snow_from_game_of_thrones => 'Джон Сноу';

  @override
  String get frog => 'Лягушка';

  @override
  String get king_of_the_hill => 'Король горы';

  @override
  String get monument => 'Памятник';

  @override
  String get sommelier => 'Сомелье';

  @override
  String get snow => 'Снег';

  @override
  String get electricity => 'Электричество';

  @override
  String get iron => 'Железо';

  @override
  String get acid => 'Кислота';

  @override
  String get milk => 'Молоко';

  @override
  String get rocket => 'Ракета';

  @override
  String get intelligence => 'Интеллект';

  @override
  String get wood => 'Древесина';

  @override
  String get wine => 'Вино';

  @override
  String get sun => 'Солнце';

  @override
  String get spark => 'Искра';

  @override
  String get robot => 'Робот';

  @override
  String get rainbow => 'Радуга';

  @override
  String get metal => 'Металл';

  @override
  String get mammal => 'Млекопитающее';

  @override
  String get light => 'Свет';

  @override
  String get life => 'Жизнь';

  @override
  String get fire => 'Огонь';

  @override
  String get earth => 'Земля';

  @override
  String get dough => 'Тесто';

  @override
  String get dolphin => 'Дельфин';

  @override
  String get cat => 'Кошка';

  @override
  String get dog => 'Собака';

  @override
  String get artificial_intelligence => 'Искус. интеллект';

  @override
  String get train => 'Поезд';

  @override
  String get mountain => 'Гора';

  @override
  String get family => 'Семья';

  @override
  String get leon => 'Лев';

  @override
  String get ballerina_cappuccino => 'Балерина капучино';

  @override
  String get bombardiro_crocodilo => 'Бомбардир крокодил';

  @override
  String get lirili_larila => 'Лирили ларила';

  @override
  String get tralalero_tralala => 'Тралалеро тралала';

  @override
  String get shark_and_nike => 'Акула и найк';

  @override
  String get hogwarts_school => 'Школа Хогвартс';

  @override
  String get march_8 => '8 марта';

  @override
  String get new_years_star => 'Новогодняя звезда';

  @override
  String get thor_man => 'Тор человек';

  @override
  String get ancient_bird => 'Древняя птица';

  @override
  String get ancient_marine_mammal => 'Древнее млекопитающее';

  @override
  String get ancient_sea_fish => 'Древняя рыба';

  @override
  String get ancient_stone_age_man_with_stone => 'Древний человек';

  @override
  String get archangel_with_wings_and_a_sword => 'Архангел';

  @override
  String get bear_on_bicycle_in_circus => 'Медведь на велосипеде';

  @override
  String get bee => 'Пчела';

  @override
  String get bone_dragon => 'Костяной дракон';

  @override
  String get burger => 'Бургер';

  @override
  String get candle => 'Свеча';

  @override
  String get church => 'Церковь';

  @override
  String get cipollino => 'Чиполлино';

  @override
  String get circus => 'Цирк';

  @override
  String get circus_clown => 'Цирковой клоун';

  @override
  String get corsair_pirate_sea => 'Корсар пират море';

  @override
  String get daenerys_targaryen => 'Дейенерис Таргариен';

  @override
  String get fire_elemental => 'Огненный элементаль';

  @override
  String get firefighter => 'Пожарный';

  @override
  String get fireworks => 'Фейерверк';

  @override
  String get fruits => 'Фрукты';

  @override
  String get gandalf_from_the_lord_of_the_rings => 'Гэндальф';

  @override
  String get girl_in_love => 'Девушка влюбленная';

  @override
  String get grandmother => 'Бабушка';

  @override
  String get guy_in_love => 'Парень влюбленный';

  @override
  String get hobbit_from_lord_of_the_rings => 'Хоббит';

  @override
  String get holiday_people => 'Праздничные люди';

  @override
  String get honeycombs => 'Соты';

  @override
  String get house_in_the_village => 'Дом в деревне';

  @override
  String get institute_education => 'Институт образование';

  @override
  String get lamb => 'Ягненок';

  @override
  String get magic_broom => 'Волшебная метла';

  @override
  String get magician_illusionist => 'Фокусник';

  @override
  String get male_scientist => 'Ученый мужчина';

  @override
  String get masks_from_the_theater => 'Маски из театра';

  @override
  String get mermaid => 'Русалка';

  @override
  String get microbes => 'Микробы';

  @override
  String get modern_sea_deck_of_ship => 'Современная палуба';

  @override
  String get modern_tool => 'Современный инструмент';

  @override
  String get multicolored_balloons => 'Воздушные шары';

  @override
  String get old_sea_deck_of_ship => 'Морская палуба корабля';

  @override
  String get people => 'Люди';

  @override
  String get pirate_ship => 'Пиратский корабль';

  @override
  String get plank_stack_folded => 'Сложенные доски';

  @override
  String get prometheus_who_gave_fire => 'Прометей';

  @override
  String get rooster => 'Петух';

  @override
  String get rope => 'Веревка';

  @override
  String get sea_sailing_ship => 'Парусный корабль';

  @override
  String get spider_man => 'Человек-паук';

  @override
  String get spider_web => 'Паутина';

  @override
  String get stone_elemental => 'Каменный элементаль';

  @override
  String get strong_man => 'Сильный мужчина';

  @override
  String get student_guy => 'Студент парень';

  @override
  String get students => 'Студенты';

  @override
  String get sword => 'Меч';

  @override
  String get the_plane_is_flying => 'Самолет летит';

  @override
  String get the_witcher_man_from_the_game => 'Ведьмак';

  @override
  String get theater_of_masks_play => 'Театр масок';

  @override
  String get thor_s_hammer => 'Молот Тора';

  @override
  String get time_machine => 'Машина времени';

  @override
  String get traveler => 'Путешественник';

  @override
  String get two_students => 'Два студента';

  @override
  String get underground_metro => 'Метро';

  @override
  String get whale => 'Кит';

  @override
  String get young_girl => 'Молодая девушка';

  @override
  String get young_guy => 'Молодой парень';

  @override
  String get frost => 'Мороз';

  @override
  String get phoenix => 'Феникс';

  @override
  String get sand => 'Песок';

  @override
  String get thunderstorm_with_lightning => 'Гроза с молнией';

  @override
  String get tornado => 'Торнадо';

  @override
  String get unicorn => 'Единорог';

  @override
  String get vampire => 'Вампир';

  @override
  String get zombie => 'Зомби';

  @override
  String get geyser => 'Гейзер';

  @override
  String get antibiotic => 'Антибиотик';

  @override
  String get electric_battery => 'Электрическая батарея';

  @override
  String get molotov_cocktail => 'Коктейль Молотова';

  @override
  String get puss_in_boots => 'Кот в сапогах';

  @override
  String get schrodingers_cat => 'Кот Шрёдингера';

  @override
  String get beehive => 'Пчелиный улей';

  @override
  String get bitcoin => 'Биткоин';

  @override
  String get cheese => 'Сыр';

  @override
  String get chocolate => 'Шоколад';

  @override
  String get pandemic => 'Пандемия';

  @override
  String get shrek => 'Шрек';

  @override
  String get gameTitle => 'Эволюция Дарвина';

  @override
  String get hintTitle => 'Подсказка';

  @override
  String get create_sun => 'Создайте солнце';

  @override
  String get ichthyostegidae => 'Ichthyostegidae';

  @override
  String get crossopterygian_fish => 'Crossopterygian fish';

  @override
  String get flower => 'Цветок';

  @override
  String get reptile => 'Пресмыкающееся';

  @override
  String get death_star => 'Звезда смерти';

  @override
  String get jedi_from_stars_wars => 'Джедай';

  @override
  String get yoda_is_a_wise_jedi => 'Йода';
}
