import 'package:flutter/material.dart';

import '../models/image_item.dart';
import '../logic/game_field_manager.dart';
import 'toolbox_item.dart';

class ToolboxPanel extends StatelessWidget {
  final double height;
  final List<ImageItem> toolboxImages;
  final FieldManager fieldManager;
  final void Function(double newHeightPercentage) onHeightChanged;
  final void Function() onItemAdded;

  const ToolboxPanel({
    required this.height,
    required this.toolboxImages,
    required this.fieldManager,
    required this.onHeightChanged,
    required this.onItemAdded,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final itemSize = screenSize.width / 4 - 12;

    return SizedBox(
      height: height,
      child: Column(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              final newHeightPercentage =
                  height / screenSize.height -
                  details.delta.dy / screenSize.height;
              onHeightChanged(newHeightPercentage.clamp(0.15, 0.4));
            },
            child: Container(
              height: 24,
              color: Colors.blueGrey[300],
              child: Center(
                child: Container(
                  width: 60,
                  height: 4,
                  color: Colors.blueGrey[500],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blueGrey[100],
              child: GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: toolboxImages.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: itemSize,
                    height: itemSize,
                    child: ToolboxItemWidget(
                      imgItem: toolboxImages[index],
                      size: itemSize,
                      fieldManager: fieldManager,
                      context: context,
                      onItemAdded: onItemAdded,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
