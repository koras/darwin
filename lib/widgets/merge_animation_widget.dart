import 'package:flutter/material.dart';
import '../models/game_item.dart';
import '../models/image_item.dart';

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
    Key? key,
  }) : super(key: key);

  @override
  _MergeAnimationWidgetState createState() => _MergeAnimationWidgetState();
}

class _MergeAnimationWidgetState extends State<MergeAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(_controller);

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 100),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Эффект вспышки
            if (_controller.value < 0.3)
              Container(
                width: widget.cellSize * 2,
                height: widget.cellSize * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(
                    0.3 * (1 - _controller.value / 0.3),
                  ),
                ),
              ),

            // Результирующий элемент
            // Результирующий элемент
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Image.asset(
                  widget.resultItem.assetPath,
                  width: widget.cellSize,
                  height: widget.cellSize,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
