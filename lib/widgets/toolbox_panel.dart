import 'package:flutter/material.dart';

import '../models/image_item.dart';
import '../logic/game_field_manager.dart';
import 'toolbox_item.dart';

// Виджет панели инструментов, содержащий элементы для перетаскивания на игровое поле
class ToolboxPanel extends StatelessWidget {
  final double height; // Текущая высота панели
  final List<ImageItem>
  toolboxImages; // Список изображений в панели инструментов
  final FieldManager
  fieldManager; // Менеджер игрового поля для управления элементами
  final void Function(double newHeightPercentage)
  onHeightChanged; // Колбэк при изменении высоты
  final void Function() onItemAdded; // Колбэк при добавлении элемента на поле

  const ToolboxPanel({
    required this.height,
    required this.toolboxImages,
    required this.fieldManager,
    required this.onHeightChanged,
    required this.onItemAdded,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Получаем размер экрана для адаптивного дизайна
    final screenSize = MediaQuery.of(context).size;
    // Рассчитываем размер каждого элемента (4 элемента в ряд с отступами)
    final itemSize = screenSize.width / 4 - 12;

    return SizedBox(
      height: height, // Фиксированная высота панели
      child: Column(
        children: [
          // Верхняя панель для изменения высоты (перетаскиванием)
          GestureDetector(
            onVerticalDragUpdate: (details) {
              // Рассчитываем новую высоту на основе движения пальца
              final newHeightPercentage =
                  height / screenSize.height -
                  details.delta.dy / screenSize.height;
              // Вызываем колбэк с новой высотой (ограниченной в диапазоне 15%-40%)
              onHeightChanged(newHeightPercentage.clamp(0.15, 0.4));
            },
            child: Container(
              height: 24,
              color: Colors.blueGrey[300],
              child: Center(
                child: Container(
                  width: 60,
                  height: 4,
                  color:
                      Colors.blueGrey[500], // Визуальный индикатор для захвата
                ),
              ),
            ),
          ),
          // Основная область с элементами инструментов
          Expanded(
            child: Container(
              color: Colors.blueGrey[100], // Фон панели инструментов
              child: GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 элемента в ряд
                  mainAxisSpacing: 8, // Вертикальные отступы
                  crossAxisSpacing: 8, // Горизонтальные отступы
                  childAspectRatio: 1, // Квадратные элементы
                ),
                itemCount: toolboxImages.length, // Количество элементов
                itemBuilder: (context, index) {
                  // Создаем виджет для каждого элемента в панели инструментов
                  return SizedBox(
                    width: itemSize,
                    height: itemSize,
                    child: ToolboxItemWidget(
                      imgItem: toolboxImages[index], // Данные изображения
                      size: itemSize, // Размер элемента
                      fieldManager: fieldManager, // Менеджер поля
                      context: context, // Контекст для диалогов и т.д.
                      onItemAdded: onItemAdded, // Колбэк при добавлении
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
