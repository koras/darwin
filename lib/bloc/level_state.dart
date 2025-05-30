part of 'level_bloc.dart';
// Добавьте эту строку

// flutter pub run build_runner build
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

  @HiveField(11)
  final String? background;

  @HiveField(12)
  final String? timeUntilNextHint;

  @HiveField(13)
  /// Все элементы, которые игрок уже открыл за уровень
  final List<String> discoveredItemsLevel;

  final String? timeStr;

  @HiveField(14)
  final int freeHints;
  // сколько бесплатных подсказок на уровне
  @HiveField(15)
  final int timeHintWait;

  @HiveField(16)
  final bool soundsEnabled;

  @HiveField(17)
  final Locale locale;

  /// Конструктор состояния уровня
  const LevelState({
    required this.currentLevel,
    required this.availableItems,
    required this.discoveredItemsLevel,
    required this.discoveredItems,
    required this.targetItem,
    required this.levelTitle,
    required this.hints,
    this.lastDiscoveredItem,
    this.gameItems, // Добавляем в конструктор
    this.showLevelComplete,
    this.completedItemId,
    this.hintsState = const HintsState(),
    this.background,
    this.timeUntilNextHint,
    this.timeStr,
    required this.freeHints,
    required this.timeHintWait,
    required this.soundsEnabled,
    required this.locale,
  });

  /// Начальное состояние уровня
  factory LevelState.initial() {
    return LevelState(
      currentLevel: 0,
      availableItems: [],
      discoveredItemsLevel: [],
      discoveredItems: [], // Инициализируем пустым списком
      targetItem: '',
      levelTitle: '',
      hints: [],
      lastDiscoveredItem: null,
      gameItems: null,
      showLevelComplete: false,
      completedItemId: null,
      hintsState: HintsState(),
      background: 'level1.png',
      timeUntilNextHint: null,
      timeStr: null,
      freeHints: 0,
      timeHintWait: 0,
      soundsEnabled: true,
      locale: Locale('en'),
    );
  }

  // level_state.dart
  LevelState copyWith({
    int? currentLevel,
    List<String>? availableItems,
    List<String>? discoveredItemsLevel,
    List<String>? discoveredItems,
    String? targetItem,
    String? levelTitle,
    List<String>? hints,
    String? lastDiscoveredItem,
    List<GameItem>? gameItems,
    bool? showLevelComplete,
    String? completedItemId,
    HintsState? hintsState,
    String? background,
    String? timeUntilNextHint,
    String? timeStr,
    int? freeHints,
    int? timeHintWait,
    bool? soundsEnabled,
    Locale? locale,
  }) {
    return LevelState(
      currentLevel: currentLevel ?? this.currentLevel,
      availableItems: availableItems ?? this.availableItems,
      discoveredItemsLevel: discoveredItemsLevel ?? this.discoveredItemsLevel,
      discoveredItems: discoveredItems ?? this.discoveredItems,
      targetItem: targetItem ?? this.targetItem,
      levelTitle: levelTitle ?? this.levelTitle,
      hints: hints ?? this.hints,
      lastDiscoveredItem: lastDiscoveredItem ?? this.lastDiscoveredItem,
      gameItems: gameItems ?? this.gameItems,
      showLevelComplete: showLevelComplete ?? this.showLevelComplete,
      completedItemId: completedItemId ?? this.completedItemId,
      hintsState: hintsState ?? this.hintsState,
      background: background ?? this.background,
      timeUntilNextHint: timeUntilNextHint ?? this.timeUntilNextHint,
      timeStr: timeStr ?? this.timeStr,
      freeHints: freeHints ?? this.freeHints,
      timeHintWait: timeHintWait ?? this.timeHintWait,

      soundsEnabled: soundsEnabled ?? this.soundsEnabled,
      locale: locale ?? this.locale,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LevelState &&
        other.currentLevel == currentLevel &&
        const ListEquality().equals(other.availableItems, availableItems) &&
        const ListEquality().equals(
          other.discoveredItemsLevel,
          discoveredItemsLevel,
        ) &&
        const ListEquality().equals(other.discoveredItems, discoveredItems) &&
        const ListEquality().equals(other.gameItems, gameItems) &&
        other.targetItem == targetItem &&
        other.hintsState == hintsState &&
        other.timeStr == timeStr &&
        other.timeHintWait == timeHintWait &&
        other.freeHints == freeHints &&
        other.timeUntilNextHint == timeUntilNextHint &&
        other.soundsEnabled == soundsEnabled &&
        other.locale == locale &&
        other.background == background;
  }

  /// Хэш-код для объекта [LevelState], используется при сравнении и хэшировании
  @override
  int get hashCode => Object.hash(
    currentLevel,
    const ListEquality().hash(availableItems),
    const ListEquality().hash(discoveredItemsLevel),
    const ListEquality().hash(discoveredItems),
    const ListEquality().hash(gameItems),
    targetItem,
    hintsState,
    timeStr,
    freeHints,
    timeUntilNextHint,
    background,
    timeUntilNextHint,
    locale,
    soundsEnabled,
  );
}

@HiveType(typeId: 4)
class HintsState {
  @HiveField(0)
  final int freeHintsUsed; // Использованные бесплатные подсказки (0-3)

  @HiveField(1)
  final int paidHintsAvailable; // Доступные платные подсказки

  @HiveField(2)
  final List<String> usedHints; // Использованные комбинации
  @HiveField(3)
  final DateTime? lastHintTime; // Время последней выданной подсказки
  @HiveField(4)
  final bool hasPendingHint; // Есть неиспользованная подсказка

  @HiveField(5)
  final String currentHint;
  // Есть неиспользованная подсказка

  @HiveField(6)
  final int freeHints; // Доступные бесплатные подсказки

  @HiveField(7)
  final int countHintsAvailable; // Доступные бесплатные подсказки

  @HiveField(8)
  // идёт ли отсчёт времени?
  final bool timeHintAvailable;

  @HiveField(9)
  /// сколько времени ждать
  final int timeHintWait;

  const HintsState({
    this.freeHintsUsed = 1,
    this.paidHintsAvailable = 0,
    this.usedHints = const [],
    this.lastHintTime,
    this.hasPendingHint = false,
    this.currentHint = '',
    // количество подсказок на уровне
    this.freeHints = 1,
    this.countHintsAvailable = 0,
    this.timeHintAvailable = false,
    this.timeHintWait = 10,
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
    bool? timeHintAvailable,
    String? currentHint,
    int? countHintsAvailable,
    int? timeHintWait,
  }) {
    return HintsState(
      freeHintsUsed: freeHintsUsed ?? this.freeHintsUsed,
      freeHints: freeHints ?? this.freeHints,
      paidHintsAvailable: paidHintsAvailable ?? this.paidHintsAvailable,
      usedHints: usedHints ?? this.usedHints,
      lastHintTime: lastHintTime ?? this.lastHintTime,
      timeHintAvailable: timeHintAvailable ?? this.timeHintAvailable,
      hasPendingHint: hasPendingHint ?? this.hasPendingHint,
      currentHint: currentHint ?? this.currentHint,
      countHintsAvailable: countHintsAvailable ?? this.countHintsAvailable,
      timeHintWait: timeHintWait ?? this.timeHintWait,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HintsState &&
        other.freeHintsUsed == freeHintsUsed &&
        other.freeHints == freeHints &&
        other.currentHint == currentHint &&
        other.paidHintsAvailable == paidHintsAvailable &&
        other.countHintsAvailable == countHintsAvailable &&
        const ListEquality().equals(other.usedHints, usedHints) &&
        other.lastHintTime == lastHintTime &&
        other.timeHintAvailable == timeHintAvailable &&
        other.timeHintWait == timeHintWait &&
        other.timeHintWait == timeHintWait &&
        other.hasPendingHint == hasPendingHint;
  }

  @override
  int get hashCode => Object.hash(
    freeHintsUsed,
    freeHints,
    paidHintsAvailable,
    const ListEquality().hash(usedHints),
    lastHintTime,
    currentHint,
    timeHintAvailable,
    timeHintWait,
    hasPendingHint,

    freeHints,
    timeHintWait,
  );
}

// class HintsStateAdapter extends TypeAdapter<HintsState> {
//   @override
//   final int typeId = 4; // Должен совпадать с typeId в аннотации HiveType

//   @override
//   HintsState read(BinaryReader reader) {
//     return HintsState(
//       freeHintsUsed: reader.read(),
//       paidHintsAvailable: reader.read(),
//       usedHints: List<String>.from(reader.read()),
//       lastHintTime: reader.read(),
//       hasPendingHint: reader.read(),
//       currentHint: reader.read(),
//       freeHints: reader.read(),
//       countHintsAvailable: reader.read(),
//       timeHintAvailable: reader.read(),
//       timeHintWait: reader.read(),
//     );
//   }

//   @override
//   void write(BinaryWriter writer, HintsState obj) {
//     writer.write(obj.freeHintsUsed);
//     writer.write(obj.paidHintsAvailable);
//     writer.write(obj.usedHints);
//     writer.write(obj.lastHintTime);
//     writer.write(obj.hasPendingHint);
//     writer.write(obj.currentHint);
//     writer.write(obj.freeHints);
//     writer.write(obj.countHintsAvailable);
//     writer.write(obj.timeHintAvailable);
//     writer.write(obj.timeHintWait);
//   }
// }
