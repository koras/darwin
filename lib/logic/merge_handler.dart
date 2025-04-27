import 'package:flutter/material.dart';
import '../models/game_item.dart';
import '../models/image_item.dart';
import '../logic/merge_logic.dart';
import '../widgets/game_snackbar.dart';
import '../widgets/merge_animation_widget.dart';
import '../bloc/level_bloc.dart';

// Класс для обработки слияния игровых элементов
class MergeHandler {
  final BuildContext context; // Контекст для доступа к UI и навигации
  final List<GameItem> gameItems; // Список игровых элементов на поле
  final Function(GameItem) onMergeComplete; // Колбэк, вызываемый после слияния
  final double cellSize; // Размер ячейки игрового поля
  final double fieldTop;

  final LevelBloc levelBloc; // Добавляем LevelBloc
  MergeHandler({
    required this.context,
    required this.gameItems,
    required this.onMergeComplete,
    required this.cellSize,
    required this.fieldTop,
    required this.levelBloc, // Добавляем в конструктор
  });

  // Пытается объединить два элемента
  bool tryMergeItems(GameItem item1, GameItem item2) {
    try {
      // Получаем ID результата слияния (null, если слияние невозможно)
      final resultId = getMergeResult(item1.id, item2.id);
      // Позиция нового элемента будет на месте второго элемента
      final int newX = item2.gridX;
      final int newY = item2.gridY;

      // Если слияние невозможно, возвращаем false
      if (resultId == null) return false;

      // Отправляем событие о новом обнаруженном предмете
      levelBloc.add(ItemDiscoveredEvent(itemId: resultId));
      // здесь добавляем новый элемент в панель
      // код добавляения

      // Находим данные результирующего элемента в списке всех возможных изображений
      print(
        'Находим данные результирующего элемента в списке всех возможных изображений ${item1.id}, ${item2.id}',
      );
      final resultItem = allImages.firstWhere(
        (resultItem) => resultItem.id == resultId,
      );
      print(' ${item1}, ${item2}');

      // Удаляем исходные элементы из списка
      gameItems.remove(item1);
      gameItems.remove(item2);

      // Показываем анимацию слияния
      _showMergeAnimation(item1, item2, resultItem);

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
    } catch (e, stackTrace) {
      // Логируем ошибку
      print('Ошибка при слиянии предметов: $e Стек вызовов: $stackTrace');

      // Можно также показать пользователю сообщение об ошибке
      GameSnackbar.show(context, 'Произошла ошибка при слиянии предметов');

      return false;
    }
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

    final item2Position = Offset(
      // position.dx +
      item2.gridX * cellSize + cellSize / 2 - 20,

      //  position.dy +
      item2.gridY * cellSize - cellSize + fieldTop + cellSize - 23,
    );

    debugPrint(
      'position====: $item2Position} Item1 ====:  ${item1.gridX}  ${item1.gridY} $fieldTop Center position: $fieldTop $item2Position',
    );
    // Создаем OverlayEntry для анимации
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: item2Position.dx,
            top: item2Position.dy,
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
