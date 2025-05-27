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
      discoveredItemsLevel: (fields[13] as List).cast<String>(),
      discoveredItems: (fields[2] as List).cast<String>(),
      targetItem: fields[3] as String,
      levelTitle: fields[4] as String,
      hints: (fields[5] as List).cast<String>(),
      lastDiscoveredItem: fields[6] as String?,
      gameItems: (fields[7] as List?)?.cast<GameItem>(),
      showLevelComplete: fields[8] as bool?,
      completedItemId: fields[9] as String?,
      hintsState: fields[10] as HintsState,
      background: fields[11] as String?,
      timeUntilNextHint: fields[12] as String?,
      freeHints: fields[14] as int,
      timeHintWait: fields[15] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LevelState obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.completedItemId)
      ..writeByte(10)
      ..write(obj.hintsState)
      ..writeByte(11)
      ..write(obj.background)
      ..writeByte(12)
      ..write(obj.timeUntilNextHint)
      ..writeByte(13)
      ..write(obj.discoveredItemsLevel);
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

class HintsStateAdapter extends TypeAdapter<HintsState> {
  @override
  final int typeId = 4;

  @override
  HintsState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HintsState(
      freeHintsUsed: fields[0] as int,
      paidHintsAvailable: fields[1] as int,
      usedHints: (fields[2] as List).cast<String>(),
      lastHintTime: fields[3] as DateTime?,
      hasPendingHint: fields[4] as bool,
      currentHint: fields[5] as String,
      freeHints: fields[6] as int,
      countHintsAvailable: fields[7] as int,
      timeHintAvailable: fields[8] as bool,
      timeHintWait: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HintsState obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.freeHintsUsed)
      ..writeByte(1)
      ..write(obj.paidHintsAvailable)
      ..writeByte(2)
      ..write(obj.usedHints)
      ..writeByte(3)
      ..write(obj.lastHintTime)
      ..writeByte(4)
      ..write(obj.hasPendingHint)
      ..writeByte(5)
      ..write(obj.currentHint)
      ..writeByte(6)
      ..write(obj.freeHints)
      ..writeByte(7)
      ..write(obj.countHintsAvailable)
      ..writeByte(8)
      ..write(obj.timeHintAvailable)
      ..writeByte(9)
      ..write(obj.timeHintWait);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HintsStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
