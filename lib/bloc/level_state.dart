// level_state.dart
part of 'level_bloc.dart';

class LevelState {
  final int currentLevel;
  final List<String> availableItems; // ID доступных элементов для уровня
  final String targetItem; // Целевой элемент, который нужно создать
  final String levelTitle;
  final Map<int, List<String>> hints; // Подсказки для уровня

  const LevelState({
    required this.currentLevel,
    required this.availableItems,
    required this.targetItem,
    required this.levelTitle,
    required this.hints,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LevelState &&
        other.currentLevel == currentLevel &&
        const ListEquality().equals(other.availableItems, availableItems) &&
        other.targetItem == targetItem;
  }

  @override
  int get hashCode => Object.hash(currentLevel, availableItems, targetItem);
}
