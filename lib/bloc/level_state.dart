part of 'level_bloc.dart';

class LevelState {
  final int value;

  const LevelState(this.value);

  // Можно добавить методы для сравнения состояний
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LevelState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
