import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class GameItem {
  final String id;
  final String key;
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
    required this.key,
    required this.slug,
    required this.assetPath,
    required this.gridX,
    required this.gridY,
  });

  GameItem copyWith({
    String? id,
    String? key,
    String? slug,
    String? assetPath,
    int? gridX,
    int? gridY,
  }) {
    return GameItem(
      id: id ?? this.id,
      key: key ?? this.key,
      slug: slug ?? this.slug,
      assetPath: assetPath ?? this.assetPath,
      gridX: gridX ?? this.gridX,
      gridY: gridY ?? this.gridY,
    );
  }
}
