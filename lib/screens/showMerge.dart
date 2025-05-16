import 'package:flutter/material.dart';
import 'package:darwin/models/game_item.dart';
import 'package:darwin/models/image_item.dart';
import 'package:darwin/models/merge_rule.dart';
import 'package:darwin/data/merge_rules.dart';

class CombinationsPage extends StatelessWidget {
  // final List<MergeRule> mergeRules;
  final List<String> discoveredItems; // Уже открытые игроком элементы

  const CombinationsPage({
    Key? key,
    //  required this.mergeRules,
    required this.discoveredItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Все комбинации'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDiscoveredSection(),
            const SizedBox(height: 34),
            _buildAllCombinationsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveredSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Открытые вами комбинации:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children:
              mergeRules
                  .where((rule) => discoveredItems.contains(rule.resultImageId))
                  .map((rule) => _buildCombinationCard(rule, true))
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildAllCombinationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Все возможные комбинации:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children:
              mergeRules
                  .map(
                    (rule) => _buildCombinationCard(
                      rule,
                      discoveredItems.contains(rule),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildCombinationCard(MergeRule rule, bool isDiscovered) {
    final item1 = _getGameItem(rule.firstImageId);
    final item2 = _getGameItem(rule.secondImageId);
    final result = _getGameItem(rule.resultImageId);

    return Card(
      color: isDiscovered ? Colors.white : Colors.grey[200],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Первый элемент
            _buildSmallItemWidget(result),
            const SizedBox(height: 4),

            // Плюс
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSmallItemWidget(item2),
                const SizedBox(width: 8),
                const Text('+', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                _buildSmallItemWidget(item1),
              ],
            ),
            const SizedBox(height: 8),

            // Название результата
            Text(
              rule.resultImageId,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDiscovered ? Colors.deepPurple : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallItemWidget(GameItem item) {
    print('path ${item.assetPath}');
    return Container(
      width: 40,
      //   height: 50,
      // width: 50,
      //  height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          // Было: border: Border.all(color: _generateCalmColor(item.id),
          color: _generateCalmColor(item.id), // Добавлена закрывающая скобка
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          item.assetPath,
          fit: BoxFit.cover,
          //    color: Colors.grey[700]?.withOpacity(0.7),
        ),
      ),
    );
  }

  GameItem _getGameItem(String id) {
    print('\n=== Поиск элемента с id: "$id" ===');

    try {
      final imageItem = allImages.firstWhere((item) => item.id == id);

      return GameItem.fromImageItem(imageItem: imageItem);
    } catch (e) {
      print('❌ Ошибка при поиске элемента: $e');
      return GameItem.fromImageItem(
        imageItem: ImageItem('error', position: Offset.zero),
      );
    }
  }

  Color _generateCalmColor(String input) {
    final hash = input.hashCode;
    return HSLColor.fromAHSL(1.0, (hash % 360).toDouble(), 0.4, 0.7).toColor();
  }
}
