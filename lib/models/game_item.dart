import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:darwin/data/image_item.dart';

part 'game_item.g.dart';

@HiveType(typeId: 2)
class GameItem {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String key;
  @HiveField(2)
  final String slug;
  @HiveField(3)
  final String assetPath;
  //Offset position; // Позиция в сетке
  @HiveField(4)
  Offset tempOffset = Offset.zero; // Временное смещение при перетаскивани
  @HiveField(5)
  Offset dragOffset;
  @HiveField(6)
  int gridX;
  @HiveField(7)
  int gridY;
  @HiveField(8)
  bool isDragging = false;

  // Параметры для анимации
  @HiveField(9)
  double scale = 1.0;
  @HiveField(10)
  double opacity = 1.0;

  GameItem({
    required this.id,
    required this.key,
    required this.slug,
    required this.assetPath,
    this.gridX = 0,
    this.gridY = 0,
    this.dragOffset = Offset.zero,
    this.isDragging = false,
    this.scale = 1.0,
    this.opacity = 1.0,
    this.tempOffset = Offset.zero,
  });

  factory GameItem.fromImageItem({required ImageItem imageItem, String? key}) {
    return GameItem(
      id: imageItem.id,
      key: key ?? imageItem.id,
      slug: imageItem.slug,
      assetPath: imageItem.assetPath,
      // gridX: gridX,
      //  gridY: gridY,
      tempOffset: imageItem.position,
    );
  }

  String getName() {
    this.id;
    return '';
  }

  GameItem copyWith({
    String? id,
    String? key,
    String? slug,
    String? assetPath,
    int? gridX,
    int? gridY,
    Offset dragOffset = Offset.zero,
    Offset? tempOffset,
    bool? isDragging,
    double? scale,
    double? opacity,
  }) {
    return GameItem(
      id: id ?? this.id,
      key: key ?? this.key,
      slug: slug ?? this.slug,
      assetPath: assetPath ?? this.assetPath,
      gridX: gridX ?? this.gridX,
      gridY: gridY ?? this.gridY,
      tempOffset: tempOffset ?? this.tempOffset,
      dragOffset: dragOffset ?? this.dragOffset,
      isDragging: isDragging ?? this.isDragging,
      scale: scale ?? this.scale,
      opacity: opacity ?? this.opacity,
    );
  }
}
