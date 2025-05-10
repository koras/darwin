import 'package:flutter/material.dart';
import '../models/game_item.dart';
import '../models/image_item.dart';
import '../logic/generate_calm_color.dart';

class MergeAnimationWidget extends StatefulWidget {
  final GameItem item1;
  final GameItem item2;
  final ImageItem resultItem;
  final double cellSize;

  static const double scale = 1.5;

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
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Создаем последовательность анимации: увеличение, затем уменьшение
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: MergeAnimationWidget.scale),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: MergeAnimationWidget.scale, end: 0.8),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Плавное начало и конец для всей анимации
      ),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = generateCalmColor(widget.resultItem.slug);
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.cellSize,
        //   height: widget.cellSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(2, 2),
            ),
          ],
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
