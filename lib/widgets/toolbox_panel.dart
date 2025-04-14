import 'package:flutter/material.dart';

import '../models/image_item.dart';
import '../logic/game_field_manager.dart';
import 'toolbox_item.dart';

class ToolboxPanel extends StatefulWidget {
  final double initialHeightPercentage; // Начальная высота в процентах
  final List<ImageItem> toolboxImages;
  final FieldManager fieldManager;
  final void Function(double newHeightPercentage) onHeightChanged;
  final void Function() onItemAdded;

  const ToolboxPanel({
    this.initialHeightPercentage = 0.25, // Делаем параметр необязательным
    required this.toolboxImages,
    required this.fieldManager,
    required this.onHeightChanged,
    required this.onItemAdded,
    Key? key,
  }) : super(key: key);

  @override
  _ToolboxPanelState createState() => _ToolboxPanelState();
}

class _ToolboxPanelState extends State<ToolboxPanel> {
  late double _currentHeightPercentage;

  @override
  void initState() {
    super.initState();
    _currentHeightPercentage = widget.initialHeightPercentage;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final height = screenSize.height * _currentHeightPercentage;
    final itemSize = screenSize.width / 4 - 12;

    return SizedBox(
      height: height,
      child: Column(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              setState(() {
                _currentHeightPercentage = (_currentHeightPercentage -
                        details.delta.dy / screenSize.height)
                    .clamp(0.15, 0.4);
              });
              widget.onHeightChanged(_currentHeightPercentage);
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
              color: const Color.fromARGB(255, 255, 255, 255),
              child: GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: widget.toolboxImages.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: itemSize,
                    height: itemSize,
                    child: ToolboxItemWidget(
                      imgItem: widget.toolboxImages[index],
                      size: itemSize,
                      fieldManager: widget.fieldManager,
                      context: context,
                      onItemAdded: widget.onItemAdded,
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
