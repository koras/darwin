import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class GameItem {
  final String id;
  final String slug;
  final String assetPath;
  //Offset position; // Позиция в сетке
  Offset tempOffset = Offset.zero; // Временное смещение при перетаскивании

  int gridX;
  int gridY;
  Offset dragOffset = Offset.zero;
  bool isDragging = false;

  // Параметры для анимации
  double scale = 1.0;
  double opacity = 1.0;

  GameItem({
    required this.id,
    required this.slug,
    required this.assetPath,
    required this.gridX,
    required this.gridY,
  });
}
