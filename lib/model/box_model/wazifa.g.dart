// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wazifa.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WazifaFavAdapter extends TypeAdapter<WazifaFav> {
  @override
  final int typeId = 2;

  @override
  WazifaFav read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WazifaFav(
      fav: fields[0] as bool,
      index: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WazifaFav obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.fav)
      ..writeByte(1)
      ..write(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WazifaFavAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
