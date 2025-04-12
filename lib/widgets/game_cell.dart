import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../models/image_item.dart';
import '../widgets/draggable_item.dart';

class GameCell extends StatelessWidget {
  final ImageItem? imageItem;
  final Function onDrop;

  const GameCell({super.key, this.imageItem, required this.onDrop});

  @override
  Widget build(BuildContext context) {
    return DragTarget<ImageItem>(
      onAccept: (imageItem) {
        onDrop(imageItem);
      },
      builder: (context, candidateItems, rejectedItems) {
        return Container(
          width: 60,
          height: 60,
          color: Colors.grey[300],
          child:
              imageItem == null
                  ? null
                  : DraggableImage(
                    imageItem: imageItem!,
                    onDragEnd: (details) {
                      // Handle onDragEnd (if needed)
                    },
                  ),
        );
      },
    );
  }
}
