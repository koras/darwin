import 'package:flutter/material.dart';

// сетка поля
class GameGrid extends StatelessWidget {
  final int rows;
  final int columns; // Новый параметр

  const GameGrid({
    Key? key,
    this.rows = 5,
    this.columns = 5, // По умолчанию 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 1,
      ),

      itemCount: rows * columns,
      itemBuilder: (context, index) {
        return Container(
          //     margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
        );
      },
    );
  }
}
