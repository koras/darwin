// level_state.dart
part of 'level_bloc.dart';

class LevelState {
  /// Текущий уровень игры (нумерация начинается с 0)
  final int currentLevel;

  /// ID элементов, доступных для комбинирования на этом уровне
  final List<String> availableItems;

  /// Все элементы, которые игрок уже открыл за всю игру
  final List<String> discoveredItems;

  /// Целевой элемент, который нужно создать на данном уровне
  final String targetItem;

  /// Заголовок уровня, отображается пользователю
  final String levelTitle;

  /// Подсказки по уровням: ключ — номер подсказки, значение — список шагов или рекомендаций
  final Map<int, List<String>> hints;

  /// Последний открытый игроком элемент (может быть null)
  final String? lastDiscoveredItem;

  // элементы на игровом поле
  final List<GameItem>? gameItems;

  final bool? showLevelComplete;
  final String? completedItemId;

  /// Конструктор состояния уровня
  const LevelState({
    required this.currentLevel,
    required this.availableItems,
    required this.discoveredItems,
    required this.targetItem,
    required this.levelTitle,
    required this.hints,
    this.lastDiscoveredItem,
    this.gameItems, // Добавляем в конструктор
    this.showLevelComplete,
    this.completedItemId,
  });

  /// Начальное состояние уровня
  factory LevelState.initial() {
    return LevelState(
      currentLevel: 0,
      availableItems: [],
      discoveredItems: [], // Инициализируем пустым списком
      targetItem: '',
      levelTitle: '',
      hints: {},
      lastDiscoveredItem: null,
      gameItems: null,
      showLevelComplete: false,
      completedItemId: null,
    );
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
    List<GameItem>? gameItems,
    bool? showLevelComplete,
    String? completedItemId,
  }) {
    return LevelState(
      currentLevel: currentLevel ?? this.currentLevel,
      availableItems: availableItems ?? this.availableItems,
      discoveredItems: discoveredItems ?? this.discoveredItems,
      targetItem: targetItem ?? this.targetItem,
      levelTitle: levelTitle ?? this.levelTitle,
      hints: hints ?? this.hints,
      lastDiscoveredItem: lastDiscoveredItem ?? this.lastDiscoveredItem,
      gameItems: gameItems ?? this.gameItems,
      showLevelComplete: showLevelComplete ?? this.showLevelComplete,
      completedItemId: completedItemId ?? this.completedItemId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LevelState &&
        other.currentLevel == currentLevel &&
        const ListEquality().equals(other.availableItems, availableItems) &&
        const ListEquality().equals(other.discoveredItems, discoveredItems) &&
        const ListEquality().equals(other.gameItems, gameItems) &&
        other.targetItem == targetItem;
  }

  /// Хэш-код для объекта [LevelState], используется при сравнении и хэшировании
  @override
  int get hashCode =>
      Object.hash(currentLevel, availableItems, discoveredItems, targetItem);
}
