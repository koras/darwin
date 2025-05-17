import 'package:flutter/material.dart';

// Импорт моделей и виджетов
import '../models/game_item.dart';
import 'dart:async'; // Добавьте эту строку в начале файла
import 'game_item_widget.dart';
import 'dragging_item_widget.dart';
import 'game_grid.dart';

// Виджет игрового поля, который отображает сетку, элементы и перетаскиваемый элемент
class GameField extends StatelessWidget {
  // Список игровых элементов для отображения
  final List<GameItem> gameItems;
  // Текущий перетаскиваемый элемент (может быть null)
  final GameItem? draggedItem;
  final mergeHandler; // Добавляем параметр
  // Размер одной ячейки сетки
  final double cellSize;
  final double topOffset; // Добавляем параметр для сдвига
  // Обработчик начала перетаскивания
  final Function(DragStartDetails) onDragStart;
  // Обработчик обновления позиции при перетаскивании
  final Function(DragUpdateDetails) onDragUpdate;
  // Обработчик окончания перетаскивания
  final Function(DragEndDetails) onDragEnd;

  final int gridColumns;
  final int gridRows;
  final double fieldTop;

  // Конструктор класса
  const GameField({
    required this.gridColumns,
    required this.gridRows,

    required this.mergeHandler, // Добавляем в конструктор
    required this.gameItems,
    required this.draggedItem,
    required this.cellSize,
    required this.fieldTop,
    required this.topOffset,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),

      child: GestureDetector(
        // При обновлении позиции пальца/мыши во время перетаскивания
        onPanUpdate: (details) {
          // Корректируем координаты с учётом сдвига
          final adjustedDetails = DragUpdateDetails(
            globalPosition: details.globalPosition - Offset(0, topOffset),
            localPosition: details.localPosition,
            delta: details.delta,
          );
          onDragUpdate(adjustedDetails);
        },
        // Когда пользователь отпускает элемент
        onPanEnd: onDragEnd,
        // Когда пользователь начинает перетаскивание
        onPanStart: (details) {
          // Корректируем координаты с учётом сдвига
          final adjustedDetails = DragStartDetails(
            globalPosition: details.globalPosition - Offset(0, topOffset),
            localPosition: details.localPosition,
          );
          onDragStart(adjustedDetails);
        },

        child: Container(
          // Серый фон игрового поля
          //     color: Colors.grey[200],
          // Stack позволяет накладывать виджеты друг на друга
          child: Stack(
            children: [
              // Отображаем сетку игрового поля (5x5)
              // GameGrid(
              //   rows: gridRows,
              //   columns: gridColumns,
              //   cellSize: cellSize,
              // ),
              // Отображаем все игровые элементы с помощью GameItemWidget
              // Преобразуем каждый элемент списка gameItems в виджет
              ...gameItems.map(
                (item) => GameItemWidget(item: item, cellSize: cellSize),
              ),

              // Если есть перетаскиваемый элемент, отображаем его поверх остальных
              if (draggedItem != null)
                DraggingItemWidget(item: draggedItem!, cellSize: cellSize),
            ],
          ),
        ),
      ),
    );
  }
}
