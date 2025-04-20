import 'package:flutter/material.dart';
import '../models/game_item.dart';
import '../models/image_item.dart';
import '../logic/merge_logic.dart';
import '../widgets/game_snackbar.dart';
import '../widgets/merge_animation_widget.dart';

// Класс для обработки слияния игровых элементов
class MergeHandler {
  final BuildContext context; // Контекст для доступа к UI и навигации
  final List<GameItem> gameItems; // Список игровых элементов на поле
  final Function(GameItem) onMergeComplete; // Колбэк, вызываемый после слияния
  final double cellSize; // Размер ячейки игрового поля

  MergeHandler({
    required this.context,
    required this.gameItems,
    required this.onMergeComplete,
    required this.cellSize,
  });

  // Пытается объединить два элемента
  bool tryMergeItems(GameItem item1, GameItem item2) {
    // Получаем ID результата слияния (null, если слияние невозможно)
    final resultId = getMergeResult(item1.id, item2.id);
    // Позиция нового элемента будет на месте второго элемента
    final int newX = item2.gridX;
    final int newY = item2.gridY;

    // Если слияние невозможно, возвращаем false
    if (resultId == null) return false;

    // Находим данные результирующего элемента в списке всех возможных изображений
    final resultItem = allImages.firstWhere(
      (resultItem) => resultItem.id == resultId,
    );

    // Показываем анимацию слияния
    _showMergeAnimation(item1, item2, resultItem);

    // Удаляем исходные элементы из списка
    gameItems.remove(item1);
    gameItems.remove(item2);

    // Создаем новый объединенный элемент
    final mergedItem = GameItem(
      id: resultItem.id,
      slug: resultItem.slug,
      assetPath: resultItem.assetPath,
      gridX: newX,
      gridY: newY,
    );

    // Добавляем новый элемент в список
    gameItems.add(mergedItem);

    // Вызываем колбэк, уведомляющий о завершении слияния
    onMergeComplete(mergedItem);

    // Показываем уведомление о полученном предмете
    GameSnackbar.show(context, 'Получено: ${resultItem.slug}');
    return true;
  }

  // Показывает анимацию слияния двух элементов
  void _showMergeAnimation(
    GameItem item1,
    GameItem item2,
    ImageItem resultItem,
  ) {
    // Получаем Overlay для отображения анимации поверх всего
    final overlay = Overlay.of(context);
    // Получаем RenderBox для расчета позиций
    final renderBox = context.findRenderObject() as RenderBox;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);

    // Рассчитываем позиции обоих элементов на экране
    final item1Position = Offset(
      position.dx + item1.gridX * cellSize + cellSize / 2,
      position.dy + item1.gridY * cellSize + cellSize / 2,
    );

    final item2Position = Offset(
      position.dx + item2.gridX * cellSize + cellSize / 2,
      position.dy + item2.gridY * cellSize + cellSize / 2,
    );

    // Центральная точка между двумя элементами - где будет анимация
    final centerPosition = Offset(
      (item1Position.dx + item2Position.dx) / 2,
      (item1Position.dy + item2Position.dy) / 2,
    );
    debugPrint(
      'Item1 position: $item1Position ${item1.gridX}  ${item1.gridY} $cellSize',
    );
    debugPrint('Item2 position: $item2Position ${item2.gridX}  ${item2.gridY}');
    debugPrint('Center position: $centerPosition');
    // Создаем OverlayEntry для анимации
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            //    left: centerPosition.dx - cellSize / 2,
            //    top: centerPosition.dy - cellSize / 2,
            left: centerPosition.dx - cellSize,
            top: centerPosition.dy - cellSize,
            child: MergeAnimationWidget(
              item1: item1,
              item2: item2,
              resultItem: resultItem,
              cellSize: cellSize,
            ),
          ),
    );

    // Вставляем анимацию в Overlay
    overlay.insert(overlayEntry);
    // Удаляем анимацию через 800 мс
    Future.delayed(Duration(milliseconds: 800), () => overlayEntry.remove());
  }
}
