import 'package:flutter/material.dart';
import '../models/game_item.dart';
import '../models/image_item.dart';
import '../logic/merge_logic.dart';
import '../widgets/game_snackbar.dart';

class MergeHandler {
  final BuildContext context;
  final List<GameItem> gameItems;
  final Function(GameItem) onMergeComplete;

  MergeHandler({
    required this.context,
    required this.gameItems,
    required this.onMergeComplete,
  });

  bool tryMergeItems(GameItem item1, GameItem item2) {
    final resultId = getMergeResult(item1.id, item2.id);
    final int newX = item2.gridX;
    final int newY = item2.gridY;

    if (resultId != null) {
      final resultItem = allImages.firstWhere(
        (resultItem) => resultItem.id == resultId,
      );

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
    return false;
  }
}
