import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../data/merge_rules.dart';

String? getMergeResult(String firstId, String secondId) {
  // Проверяем правила в обоих направлениях (A+B и B+A)
  final rule = mergeRules.firstWhereOrNull(
    (rule) =>
        (rule.firstImageId == firstId && rule.secondImageId == secondId) ||
        (rule.firstImageId == secondId && rule.secondImageId == firstId),
  );
  return rule?.resultImageId;
}

/// Определяет ячейку сетки по координатам касания
/// Возвращает Map с координатами ячейки {'x': x, 'y': y} или null, если касание вне поля
Map<String, int> getCellFromCoordinates(
  Offset position,
  double cellSize,
  double fieldTopOffset,
) {
  // Преобразуем глобальные координаты в локальные относительно игрового поля
  final localX = position.dx;
  final localY = position.dy - fieldTopOffset;

  print('fieldTopOffset ${fieldTopOffset}');
  // Проверяем, что касание в пределах игрового поля
  final cellX = (localX / cellSize).floor();
  final cellY = (localY / cellSize).floor();

  return {'gridX': cellX, 'gridY': cellY};
}

/// Получаем координаты
Offset getCoorStatic(
  Map<String, int> params,
  double cellSize,
  double fieldTopOffset,
  double toolboxHeight,
) {
  final x = params['gridX']! * cellSize + (cellSize / 2);

  final y =
      params['gridY']! * cellSize + (cellSize / 2) + toolboxHeight.toInt();

  return Offset(x.toDouble(), y.toDouble());
}
