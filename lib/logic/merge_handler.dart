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

  void tryMergeItems(GameItem item1, GameItem item2) {
    final resultId = getMergeResult(item1.id, item2.id);

    if (resultId != null) {
      final resultItem = allImages.firstWhere((img) => img.id == resultId);

      // Удаляем исходные элементы
      gameItems.remove(item1);
      gameItems.remove(item2);

      // Создаем новый элемент
      final mergedItem = GameItem(
        id: resultItem.id,
        slug: resultItem.slug,
        assetPath: resultItem.assetPath,
        gridX: item1.gridX,
        gridY: item1.gridY,
      );

      // Добавляем новый элемент
      gameItems.add(mergedItem);

      // Уведомляем о завершении слияния
      onMergeComplete(mergedItem);

      // Показываем сообщение
      GameSnackbar.show(context, 'Получено: ${resultItem.slug}');
    }
  }
}
