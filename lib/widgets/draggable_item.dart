import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../models/image_item.dart';

class DraggableImage extends StatelessWidget {
  final ImageItem image;
  final Function(Offset) onDragEnd;

  const DraggableImage({required this.image, required this.onDragEnd});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: image.position.dx,
      top: image.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          onDragEnd(image.position + details.delta);
        },
        child: Image.asset(image.assetPath, width: 80, height: 80),
      ),
    );
  }
}
