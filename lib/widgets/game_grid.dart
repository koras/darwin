import 'package:flutter/material.dart';

class GameGrid extends StatelessWidget {
  final int rows;
  final int columns;
  final double cellSize;

  const GameGrid({
    super.key,
    this.rows = 5,
    this.columns = 5,
    this.cellSize = 60.0, // Размер ячейки по умолчанию
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 1,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
      ),
      itemCount: rows * columns,
      itemBuilder: (context, index) {
        final x = index % columns;
        final y = index ~/ columns;

        // Получаем RenderBox для преобразования координат
        return LayoutBuilder(
          builder: (context, constraints) {
            final boxSize = constraints.maxWidth; // Размер ячейки

            return Center(
              child: Container(
                width: boxSize,
                height: boxSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: Builder(
                  builder: (context) {
                    // Получаем глобальные координаты ячейки
                    final RenderBox? renderBox =
                        context.findRenderObject() as RenderBox?;
                    final Offset? globalPosition = renderBox?.localToGlobal(
                      Offset.zero,
                    );

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '($x, $y)', // Логические координаты
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${globalPosition?.dx.toStringAsFixed(1)}, '
                            '${globalPosition?.dy.toStringAsFixed(1)}',
                            style: TextStyle(fontSize: 10, color: Colors.blue),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
