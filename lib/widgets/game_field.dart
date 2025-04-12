import 'package:flutter/material.dart';

// Импорт моделей и виджетов
import '../models/game_item.dart';
import 'game_grid.dart';
import 'game_item_widget.dart';
import 'dragging_item_widget.dart';

// Виджет игрового поля, который отображает сетку, элементы и перетаскиваемый элемент
class GameField extends StatelessWidget {
  // Список игровых элементов для отображения
  final List<GameItem> gameItems;
  // Текущий перетаскиваемый элемент (может быть null)
  final GameItem? draggedItem;
  // Размер одной ячейки сетки
  final double cellSize;
  // Обработчик начала перетаскивания
  final Function(DragStartDetails) onDragStart;
  // Обработчик обновления позиции при перетаскивании
  final Function(DragUpdateDetails) onDragUpdate;
  // Обработчик окончания перетаскивания
  final Function(DragEndDetails) onDragEnd;

  // Конструктор класса
  const GameField({
    required this.gameItems,
    required this.draggedItem,
    required this.cellSize,
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
        onPanUpdate: onDragUpdate,
        // Когда пользователь отпускает элемент
        onPanEnd: onDragEnd,
        // Когда пользователь начинает перетаскивание
        onPanStart: onDragStart,
        child: Container(
          // Серый фон игрового поля
          color: Colors.grey[200],
          // Stack позволяет накладывать виджеты друг на друга
          child: Stack(
            children: [
              // Отображаем сетку игрового поля (5x5)
              GameGrid(rows: 7, columns: 7),

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
