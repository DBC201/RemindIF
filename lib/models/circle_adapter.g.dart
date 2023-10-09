// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CircleAdapterAdapter extends TypeAdapter<CircleAdapter> {
  @override
  final int typeId = 0;

  @override
  CircleAdapter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CircleAdapter(
      title: fields[0] as String,
      latitude: fields[1] as double,
      longtitude: fields[2] as double,
      radius: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CircleAdapter obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longtitude)
      ..writeByte(3)
      ..write(obj.radius);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CircleAdapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
