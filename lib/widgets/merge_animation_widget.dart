import 'package:flutter/material.dart';
import '../models/game_item.dart';
import '../models/image_item.dart';
import '../logic/generate_calm_color.dart';

class MergeAnimationWidget extends StatefulWidget {
  final GameItem item1;
  final GameItem item2;
  final ImageItem resultItem;
  final double cellSize;

  const MergeAnimationWidget({
    required this.item1,
    required this.item2,
    required this.resultItem,
    required this.cellSize,
  });

  @override
  _MergeAnimationWidgetState createState() => _MergeAnimationWidgetState();
}

class _MergeAnimationWidgetState extends State<MergeAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = generateCalmColor(widget.resultItem.slug);
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.cellSize,
        height: widget.cellSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 1),
        ),
        child: ClipOval(
          child: Image.asset(widget.resultItem.assetPath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
