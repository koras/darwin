import 'package:darwin/models/game_item.dart';
import 'package:flutter/material.dart';
import '../models/image_item.dart';

class MergeSuccessBanner extends StatelessWidget {
  final GameItem? resultItem;
  final VoidCallback onClose;

  final Animation<double> opacityAnimation;
  final Animation<double> scaleAnimation;

  const MergeSuccessBanner({
    required this.resultItem,
    required this.onClose,
    required this.opacityAnimation,
    required this.scaleAnimation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([opacityAnimation, scaleAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: opacityAnimation.value,
          child: Transform.scale(scale: scaleAnimation.value, child: child),
        );
      },
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Поздравляем!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Вы открыли новый предмет:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Image.asset(resultItem!.assetPath, width: 100, height: 100),
                const SizedBox(height: 20),
                Text(
                  resultItem!.id,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Следующий уровень',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
