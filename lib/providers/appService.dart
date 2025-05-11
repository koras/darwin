import 'package:flutter/foundation.dart';

import '../services/hive_service.dart';

class AppLevelProviders extends ChangeNotifier {
  int _levels = 1;

  AppLevelProviders({int initialLevels = 1}) : _levels = initialLevels;

  int get points => _levels;

  Future<void> addPoints(int _levels) async {
    _levels += _levels;
    await HiveService.saveLevel(_levels);
    notifyListeners();
  }

  Future<int> loadLevel() async {
    return HiveService.loadLevel();
  }
}
