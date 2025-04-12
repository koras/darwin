import 'package:flutter/material.dart';
import '../models/game_item.dart';

class GameItemWidget extends StatelessWidget {
  final GameItem item;
  final double cellSize;

  const GameItemWidget({Key? key, required this.item, required this.cellSize})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: item.gridX * cellSize + cellSize * 0.1,
      top: item.gridY * cellSize + cellSize * 0.1,
      child: GestureDetector(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: cellSize * 0.8,
              height: cellSize * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),

              child: Image.asset(item.assetPath, fit: BoxFit.contain),
            ),
            Text(
              item.slug, // Предполагая, что в GameItem есть поле name
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
