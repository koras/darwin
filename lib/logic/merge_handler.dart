import 'package:flutter/material.dart';
import '../models/game_item.dart';
import '../models/image_item.dart';
import '../logic/merge_logic.dart';
import '../widgets/game_snackbar.dart';
import '../widgets/merge_animation_widget.dart';

class MergeHandler {
  final BuildContext context;
  final List<GameItem> gameItems;
  final Function(GameItem) onMergeComplete;
  final double cellSize; // Добавляем cellSize как поле класса

  MergeHandler({
    required this.context,
    required this.gameItems,
    required this.onMergeComplete,
    required this.cellSize, // Добавляем в конструктор
  });

  bool tryMergeItems(GameItem item1, GameItem item2) {
    final resultId = getMergeResult(item1.id, item2.id);
    final int newX = item2.gridX;
    final int newY = item2.gridY;

    if (resultId == null) return false;

    final resultItem = allImages.firstWhere(
      (resultItem) => resultItem.id == resultId,
    );
    // Показываем анимацию перед слиянием
    _showMergeAnimation(item1, item2, resultItem);

    // debugPrint('Один или оба элемента уже были удалены ${resultItem.id}');
    // Проверяем, что элементы еще существуют в списке (на случай, если они уже были удалены)

    // Удаляем исходные элементы
    gameItems.remove(item1);
    gameItems.remove(item2);

    // Создаем новый элемент
    final mergedItem = GameItem(
      id: resultItem.id,
      slug: resultItem.slug,
      assetPath: resultItem.assetPath,
      gridX: newX,
      gridY: newY,
    );

    // Добавляем новый элемент
    gameItems.add(mergedItem);

    // debugPrint(
    //   'Добавлен новый элемент: ${mergedItem.id} в позицию ($newX, $newY)',
    // );

    // Уведомляем о завершении слияния
    onMergeComplete(mergedItem);

    // Показываем сообщение
    GameSnackbar.show(context, 'Получено: ${resultItem.slug}');
    return true;
  }

  void _showMergeAnimation(
    GameItem item1,
    GameItem item2,
    ImageItem resultItem,
  ) {
    final overlay = Overlay.of(context);
    final renderBox1 = context.findRenderObject() as RenderBox;
    final position1 = renderBox1.localToGlobal(Offset.zero);

    final item1Position = Offset(
      position1.dx + item1.gridX * cellSize + cellSize / 2,
      position1.dy + item1.gridY * cellSize + cellSize / 2,
    );

    final item2Position = Offset(
      position1.dx + item2.gridX * cellSize + cellSize / 2,
      position1.dy + item2.gridY * cellSize + cellSize / 2,
    );

    final centerPosition = Offset(
      (item1Position.dx + item2Position.dx) / 2,
      (item1Position.dy + item2Position.dy) / 2,
    );

    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: centerPosition.dx - cellSize / 2,
            top: centerPosition.dy - cellSize / 2,
            child: MergeAnimationWidget(
              item1: item1,
              item2: item2,
              resultItem: resultItem,
              cellSize: cellSize,
            ),
          ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(milliseconds: 800), () => overlayEntry.remove());
  }
}
