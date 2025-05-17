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
}
