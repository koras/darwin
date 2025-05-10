// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameItemAdapter extends TypeAdapter<GameItem> {
  @override
  final int typeId = 2;

  @override
  GameItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameItem(
      id: fields[0] as String,
      key: fields[1] as String,
      slug: fields[2] as String,
      assetPath: fields[3] as String,
      gridX: fields[6] as int,
      gridY: fields[7] as int,
      dragOffset: fields[5] as Offset,
      isDragging: fields[8] as bool,
      scale: fields[9] as double,
      opacity: fields[10] as double,
      tempOffset: fields[4] as Offset,
    );
  }

  @override
  void write(BinaryWriter writer, GameItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.key)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.assetPath)
      ..writeByte(4)
      ..write(obj.tempOffset)
      ..writeByte(5)
      ..write(obj.dragOffset)
      ..writeByte(6)
      ..write(obj.gridX)
      ..writeByte(7)
      ..write(obj.gridY)
      ..writeByte(8)
      ..write(obj.isDragging)
      ..writeByte(9)
      ..write(obj.scale)
      ..writeByte(10)
      ..write(obj.opacity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
