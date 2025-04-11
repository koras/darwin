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
  ImageItem('apple', 'apple', 'assets/images/apple.png'),
  ImageItem('banana', 'banana', 'assets/images/banana.png'),
  ImageItem('orange', 'orange', 'assets/images/orange.png'),
  ImageItem('fruit_basket', 'fruit_basket', 'assets/images/fruit_basket.png'),
  ImageItem('smoothie', 'smoothie', 'assets/images/smoothie.png'),
];
