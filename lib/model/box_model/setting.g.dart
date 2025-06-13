// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CounterStateAdapter extends TypeAdapter<CounterState> {
  @override
  final int typeId = 1;

  @override
  CounterState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CounterState(
      previous: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CounterState obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.previous);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
