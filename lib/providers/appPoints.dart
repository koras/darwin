import 'package:flutter/foundation.dart';

class AppPointsProviders extends ChangeNotifier {
  int _points = 0;

  int get points => _points;

  void increment() {
    _points++;
    notifyListeners(); // Уведомляем слушателей об изменении
  }
}
