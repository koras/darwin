part of 'level_bloc.dart';
// Добавьте эту строку

@HiveType(typeId: 1)
class LevelState {
  /// Текущий уровень игры (нумерация начинается с 0)
  @HiveField(0)
  final int currentLevel;

  /// ID элементов, доступных для комбинирования на этом уровне
  @HiveField(1)
  final List<String> availableItems;

  /// Все элементы, которые игрок уже открыл за всю игру
  @HiveField(2)
  final List<String> discoveredItems;

  /// Целевой элемент, который нужно создать на данном уровне
  @HiveField(3)
  final String targetItem;

  /// Заголовок уровня, отображается пользователю
  @HiveField(4)
  final String levelTitle;

  /// Подсказки по уровням: ключ — номер подсказки, значение — список шагов или рекомендаций
  @HiveField(5)
  final List<String> hints;

  /// Последний открытый игроком элемент (может быть null)
  @HiveField(6)
  final String? lastDiscoveredItem;

  // элементы на игровом поле
  @HiveField(7)
  final List<GameItem>? gameItems;

  @HiveField(8)
  final bool? showLevelComplete;

  @HiveField(9)
  final String? completedItemId;

  @HiveField(10)
  final HintsState hintsState;

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
    this.hintsState = const HintsState(),
  });

  /// Начальное состояние уровня
  factory LevelState.initial() {
    return LevelState(
      currentLevel: 0,
      availableItems: [],
      discoveredItems: [], // Инициализируем пустым списком
      targetItem: '',
      levelTitle: '',
      hints: [],
      lastDiscoveredItem: null,
      gameItems: null,
      showLevelComplete: false,
      completedItemId: null,
      hintsState: HintsState(),
    );
  }

  // level_state.dart
  LevelState copyWith({
    int? currentLevel,
    List<String>? availableItems,
    List<String>? discoveredItems,
    String? targetItem,
    String? levelTitle,
    List<String>? hints,
    String? lastDiscoveredItem,
    List<GameItem>? gameItems,
    bool? showLevelComplete,
    String? completedItemId,
    HintsState? hintsState,
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
      hintsState: hintsState ?? this.hintsState,
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
        other.targetItem == targetItem &&
        other.hintsState == hintsState;
  }

  /// Хэш-код для объекта [LevelState], используется при сравнении и хэшировании
  @override
  int get hashCode => Object.hash(
    currentLevel,
    const ListEquality().hash(availableItems),
    const ListEquality().hash(discoveredItems),
    const ListEquality().hash(gameItems),
    targetItem,
    hintsState,
  );
}

@HiveType(typeId: 4)
class HintsState {
  @HiveField(0)
  final int freeHintsUsed; // Использованные бесплатные подсказки (0-3)
  @HiveField(1)
  final int paidHintsAvailable; // Доступные платные подсказки

  @HiveField(6)
  final int freeHints; // Доступные бесплатные подсказки

  @HiveField(2)
  final List<String> usedHints; // Использованные комбинации
  @HiveField(3)
  final DateTime? lastHintTime; // Время последней выданной подсказки
  @HiveField(4)
  final bool hasPendingHint; // Есть неиспользованная подсказка

  @HiveField(5)
  final String currentHint;
  // Есть неиспользованная подсказка

  const HintsState({
    this.freeHintsUsed = 3,
    this.paidHintsAvailable = 0,
    this.usedHints = const [],
    this.lastHintTime,
    this.hasPendingHint = false,
    this.currentHint = '',
    this.freeHints = 3,
  });

  bool get getPaidHints {
    print('getPaidHints paidHintsAvailable ${paidHintsAvailable}');
    if (paidHintsAvailable > 0) {
      return true;
    }

    return false;
  }

  bool get canGetFreeHint {
    print(' canGetFreeHint freeHintsUsed ${freeHintsUsed}');

    // можем использовать 3 подсказки на уровне
    if (freeHints > 0) return true;
    return false;

    if (lastHintTime == null) return true;
    if (hasPendingHint) return false;

    final now = DateTime.now();
    return now.difference(lastHintTime!).inHours >= 3;
  }

  bool get hasActiveHint => currentHint != null;

  HintsState copyWith({
    int? freeHintsUsed,
    int? freeHints,
    int? paidHintsAvailable,
    List<String>? usedHints,
    DateTime? lastHintTime,
    bool? hasPendingHint,
    String? currentHint,
  }) {
    return HintsState(
      freeHintsUsed: freeHintsUsed ?? this.freeHintsUsed,
      freeHints: freeHints ?? this.freeHints,
      paidHintsAvailable: paidHintsAvailable ?? this.paidHintsAvailable,
      usedHints: usedHints ?? this.usedHints,
      lastHintTime: lastHintTime ?? this.lastHintTime,
      hasPendingHint: hasPendingHint ?? this.hasPendingHint,
      currentHint: currentHint ?? this.currentHint,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HintsState &&
        other.freeHintsUsed == freeHintsUsed &&
        other.freeHints == freeHints &&
        other.paidHintsAvailable == paidHintsAvailable &&
        const ListEquality().equals(other.usedHints, usedHints) &&
        other.lastHintTime == lastHintTime &&
        other.hasPendingHint == hasPendingHint;
  }

  @override
  int get hashCode => Object.hash(
    freeHintsUsed,
    freeHints,
    paidHintsAvailable,
    const ListEquality().hash(usedHints),
    lastHintTime,
    hasPendingHint,
  );
}
