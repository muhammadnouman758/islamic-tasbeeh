// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasbih.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TasbihXAdapter extends TypeAdapter<TasbihX> {
  @override
  final int typeId = 3;

  @override
  TasbihX read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TasbihX(
      minute: fields[0] as int,
      second: fields[1] as int,
      count: fields[2] as int,
      limit: fields[3] as int,
      laps: fields[4] as int,
      tasbihText: fields[5] as String,
      isRunning: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TasbihX obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.minute)
      ..writeByte(1)
      ..write(obj.second)
      ..writeByte(2)
      ..write(obj.count)
      ..writeByte(3)
      ..write(obj.limit)
      ..writeByte(4)
      ..write(obj.laps)
      ..writeByte(5)
      ..write(obj.tasbihText)
      ..writeByte(6)
      ..write(obj.isRunning);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasbihXAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
