// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_bloc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelStateAdapter extends TypeAdapter<LevelState> {
  @override
  final int typeId = 1;

  @override
  LevelState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LevelState(
      currentLevel: fields[0] as int,
      availableItems: (fields[1] as List).cast<String>(),
      discoveredItems: (fields[2] as List).cast<String>(),
      targetItem: fields[3] as String,
      levelTitle: fields[4] as String,
      hints: (fields[5] as Map).map(
        (dynamic k, dynamic v) =>
            MapEntry(k as int, (v as List).cast<String>()),
      ),
      lastDiscoveredItem: fields[6] as String?,
      gameItems: (fields[7] as List?)?.cast<GameItem>(),
      showLevelComplete: fields[8] as bool?,
      completedItemId: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LevelState obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.currentLevel)
      ..writeByte(1)
      ..write(obj.availableItems)
      ..writeByte(2)
      ..write(obj.discoveredItems)
      ..writeByte(3)
      ..write(obj.targetItem)
      ..writeByte(4)
      ..write(obj.levelTitle)
      ..writeByte(5)
      ..write(obj.hints)
      ..writeByte(6)
      ..write(obj.lastDiscoveredItem)
      ..writeByte(7)
      ..write(obj.gameItems)
      ..writeByte(8)
      ..write(obj.showLevelComplete)
      ..writeByte(9)
      ..write(obj.completedItemId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
