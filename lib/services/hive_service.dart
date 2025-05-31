import 'package:hive_flutter/hive_flutter.dart';
import '../bloc/level_bloc.dart';

class HiveService {
  static const String _levelBoxName = 'gameProgress';
  static const String gameStateBox = 'gameState';
  static const String settingsBox = 'settings';
  static const String levelStateKey = 'levelState';
  static const String hintsKey = 'hints';
  static const String levelKey = 'level';

  static Box<LevelState>? _gameStateBox;
  static Box? _settingsBox;
  static Box? _levelProgressBox;

  static Future<void> init() async {
    // Инициализация Hive
    await Hive.initFlutter();
    // Hive.registerAdapter(LevelStateAdapter());

    // Регистрация адаптеров (если есть кастомные модели)
    // Hive.registerAdapter(MyModelAdapter());

    // Открытие боксов (аналог таблиц в SQL)
    await Hive.openBox<LevelState>(gameStateBox);
    await Hive.openBox(settingsBox);

    _gameStateBox ??= await Hive.openBox<LevelState>('gameState');
    _settingsBox ??= await Hive.openBox('settings');
    _levelProgressBox ??= await Hive.openBox('gameProgress');
  }

  // Сохранение информации о подсказках
  static Future<void> saveHints(Map<String, dynamic> hints) async {
    final box = Hive.box(settingsBox);
    await box.put(hintsKey, hints);
  }

  // Загрузка информации о подсказках
  static Map<String, dynamic> loadHints() {
    final box = Hive.box(settingsBox);
    return box.get(
      hintsKey,
      defaultValue: {
        'freeHintsUsed': 0,
        'lastFreeHintTime': DateTime.now().toString(),
        'purchasedHints': 0,
      },
    );
  }

  // Сохранение на каком уровне
  // static Future<void> saveLevel(int level) async {
  //   final box = Hive.box(settingsBox);
  //   await box.put(levelKey, level);
  // }
  static Future<void> saveLevel(int level) async {
    await init(); // Убедимся, что бокс открыт
    await _settingsBox?.put('level', level);
  }

  // Загрузка текущего уровня
  static int loadLevel() {
    return _settingsBox?.get('level', defaultValue: 1) ?? 1;
  }

  // Сохранение всего состояния уровня (если нужно)
  static Future<void> saveLevelState(LevelState state) async {
    final box = Hive.box(_levelBoxName);
    await box.put('levelState', state);
  }

  // Загрузка всего состояния уровня (если нужно)
  static LevelState? loadLevelState() {
    final box = Hive.box(_levelBoxName);
    return box.get('levelState');
  }

  // Пример метода для сохранения данных
  static Future<void> saveData(
    String boxName,
    String key,
    dynamic value,
  ) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  // Пример метода для чтения данных
  static dynamic getData(String boxName, String key) {
    final box = Hive.box(boxName);
    return box.get(key);
  }

  // Пример метода для удаления данных
  static Future<void> deleteData(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }
}
