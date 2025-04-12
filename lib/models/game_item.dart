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

  GameItem({
    required this.id,
    required this.slug,
    required this.assetPath,
    required this.gridX,
    required this.gridY,
  });
}
