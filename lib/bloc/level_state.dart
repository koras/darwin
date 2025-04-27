// level_state.dart
part of 'level_bloc.dart';

class LevelState {
  final int currentLevel;
  final List<String> availableItems; // ID доступных элементов для уровня
  final List<String> discoveredItems; // Новое поле для всех открытых предметов
  final String targetItem; // Целевой элемент, который нужно создать
  final String levelTitle;
  final Map<int, List<String>> hints; // Подсказки для уровня
  final String? lastDiscoveredItem; // Новое поле

  const LevelState({
    required this.currentLevel,
    required this.availableItems,
    required this.discoveredItems,
    required this.targetItem,
    required this.levelTitle,
    required this.hints,
    this.lastDiscoveredItem, // Добавляем в конструктор
  });

  factory LevelState.initial() {
    return LevelState(
      currentLevel: 0,
      availableItems: [],
      discoveredItems: [], // Инициализируем пустым списком
      targetItem: '',
      levelTitle: '',
      hints: {},
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LevelState &&
        other.currentLevel == currentLevel &&
        const ListEquality().equals(other.availableItems, availableItems) &&
        const ListEquality().equals(other.discoveredItems, discoveredItems) &&
        other.targetItem == targetItem;
  }

  // level_state.dart
  LevelState copyWith({
    int? currentLevel,
    List<String>? availableItems,
    List<String>? discoveredItems,
    String? targetItem,
    String? levelTitle,
    Map<int, List<String>>? hints,
    String? lastDiscoveredItem,
  }) {
    return LevelState(
      currentLevel: currentLevel ?? this.currentLevel,
      availableItems: availableItems ?? this.availableItems,
      discoveredItems: discoveredItems ?? this.discoveredItems,
      targetItem: targetItem ?? this.targetItem,
      levelTitle: levelTitle ?? this.levelTitle,
      hints: hints ?? this.hints,
      lastDiscoveredItem: lastDiscoveredItem ?? this.lastDiscoveredItem,
    );
  }

  @override
  int get hashCode =>
      Object.hash(currentLevel, availableItems, discoveredItems, targetItem);
}
