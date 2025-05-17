import 'package:flutter/material.dart';
import 'package:darwin/models/game_item.dart';
import 'package:darwin/data/image_item.dart';
import 'package:darwin/data/merge_rule.dart';
import 'package:darwin/data/merge_rules.dart';

class CombinationsPage extends StatelessWidget {
  final List<String> discoveredItems;

  const CombinationsPage({Key? key, required this.discoveredItems})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Все комбинации'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDiscoveredSection(),
            const SizedBox(height: 24),
            _buildAllCombinationsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveredSection() {
    final discoveredRules =
        mergeRules
            .where((rule) => discoveredItems.contains(rule.resultImageId))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Открытые вами комбинации:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildCombinationsTable(discoveredRules, true),
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
        _buildCombinationsTable(mergeRules, false),
      ],
    );
  }

  Widget _buildCombinationsTable(List<MergeRule> rules, bool isDiscovered) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FixedColumnWidth(40),
        2: FlexColumnWidth(2),
        3: FixedColumnWidth(40),
        4: FlexColumnWidth(2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // Заголовки столбцов
        TableRow(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          children: [
            _buildHeaderCell('Элемент 1'),
            _buildHeaderCell(''),
            _buildHeaderCell('Элемент 2'),
            _buildHeaderCell(''),
            _buildHeaderCell('Результат'),
          ],
        ),
        // Строки с комбинациями
        ...rules.map((rule) => _buildTableRow(rule, isDiscovered)).toList(),
      ],
    );
  }

  TableCell _buildHeaderCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  TableRow _buildTableRow(MergeRule rule, bool isDiscovered) {
    final item1 = _getGameItem(rule.firstImageId);
    final item2 = _getGameItem(rule.secondImageId);
    final result = _getGameItem(rule.resultImageId);

    return TableRow(
      decoration: BoxDecoration(
        color: isDiscovered ? Colors.white : Colors.grey[100],
      ),
      children: [
        _buildElementCell(item1, rule.firstImageId),
        _buildOperatorCell('+'),
        _buildElementCell(item2, rule.secondImageId),
        _buildOperatorCell('='),
        _buildResultCell(result, rule.resultImageId, isDiscovered),
      ],
    );
  }

  TableCell _buildElementCell(GameItem item, String id) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallItemWidget(item),
            const SizedBox(height: 4),
            Text(id, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  TableCell _buildOperatorCell(String operator) {
    return TableCell(
      child: Center(
        child: Text(
          operator,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  TableCell _buildResultCell(GameItem item, String id, bool isDiscovered) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSmallItemWidget(item),
            const SizedBox(height: 4),
            Text(
              id,
              style: TextStyle(
                fontSize: 12,
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
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _generateCalmColor(item.id)),
      ),
      child: ClipOval(
        child: Image.asset(
          item.assetPath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Center(child: Text(item.id[0])),
        ),
      ),
    );
  }

  GameItem _getGameItem(String id) {
    try {
      final imageItem = allImages.firstWhere((item) => item.id == id);
      return GameItem.fromImageItem(imageItem: imageItem);
    } catch (e) {
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
