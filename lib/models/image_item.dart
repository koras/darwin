import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class ImageItem {
  final String id;
  final String slug;
  final String assetPath;
  Offset position;
  ImageItem(this.id, this.slug, this.assetPath, {this.position = Offset.zero});
}

final List<ImageItem> allImages = [
  ImageItem('water', 'water', 'assets/images/water.png'),
  ImageItem('cloud', 'cloud', 'assets/images/cloud.png'),
  ImageItem('dnk', 'dnk', 'assets/images/dnk.png'),
  ImageItem('man', 'man', 'assets/images/man.png'),
  ImageItem('morning', 'morning', 'assets/images/morning.png'),
  ImageItem('mushroom', 'mushroom', 'assets/images/mushroom.png'),
  ImageItem('sky', 'sky', 'assets/images/sky.png'),
  ImageItem('sugar', 'sugar', 'assets/images/sugar.png'),
  ImageItem('wind', 'wind', 'assets/images/wind.png'),
];
