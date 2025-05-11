import 'package:flutter/foundation.dart';

import '../services/hive_service.dart';

class AppLevelProviders extends ChangeNotifier {
  int _currentLevel = 1;

  AppLevelProviders() {
    _loadInitialLevel();
  }

  int get currentLevel => _currentLevel;

  Future<void> _loadInitialLevel() async {
    _currentLevel = await HiveService.loadLevel();
    notifyListeners();
  }

  Future<void> updateLevel(int newLevel) async {
    _currentLevel = newLevel;
    await HiveService.saveLevel(newLevel);
    notifyListeners();
  }

  Future<void> addPoints(int _levels) async {
    _levels += _levels;
    await HiveService.saveLevel(_levels);
    notifyListeners();
  }
}
