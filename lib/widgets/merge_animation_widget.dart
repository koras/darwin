import 'package:flutter/material.dart';
import '../models/game_item.dart';
import '../models/image_item.dart';

/// Виджет анимации слияния двух игровых элементов
/// Показывает эффект слияния с анимацией масштабирования и появления
class MergeAnimationWidget extends StatefulWidget {
  final GameItem item1; // Первый элемент для слияния
  final GameItem item2; // Второй элемент для слияния
  final ImageItem resultItem; // Результирующий элемент после слияния
  final double cellSize; // Размер ячейки для правильного масштабирования

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
  late Animation<double> _scaleAnimation; // Анимация масштабирования
  late Animation<double> _opacityAnimation; // Анимация прозрачности

  static const _animationDuration = Duration(milliseconds: 800);
  static const _flashEffectDuration = 0.3; // 30% от времени анимации
  static const _initialScale = 0.5;
  static const _maxScale = 1.2;

  @override
  void initState() {
    super.initState();
    // Инициализация контроллера анимации длительностью 800 мс
    _controller = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    // Настройка анимации масштабирования:
    // 1. Увеличение от 0.5 до 1.2 (50% времени)
    // 2. Уменьшение от 1.2 до 1.0 (оставшиеся 50%)
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: _initialScale, end: _maxScale),
        weight: 50,
      ),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(_controller);

    // Настройка анимации прозрачности:
    // Плавное появление от 0.0 до 1.0
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 100),
    ]).animate(_controller);

    // Запуск анимации сразу при инициализации
    _controller.forward();
  }

  @override
  void dispose() {
    // Важно освобождать ресурсы анимации
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
            // Эффект белой вспышки в начале анимации (первые 30% времени)
            if (_controller.value < _flashEffectDuration)
              Container(
                width: widget.cellSize * 2,
                height: widget.cellSize * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // Прозрачность уменьшается по мере прогресса анимации
                  color: Colors.white.withOpacity(
                    0.3 * (1 - _controller.value / 0.3),
                  ),
                ),
              ),

            // Анимированный результирующий элемент
            Transform.scale(
              scale: _scaleAnimation.value, // Применяем масштабирование
              child: Opacity(
                opacity: _opacityAnimation.value, // Применяем прозрачность
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
