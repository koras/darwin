import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    // Инициализация Hive
    await Hive.initFlutter();

    // Регистрация адаптеров (если есть кастомные модели)
    // Hive.registerAdapter(MyModelAdapter());

    // Открытие боксов (аналог таблиц в SQL)
    await Hive.openBox('settings');
    await Hive.openBox('gameState');
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
