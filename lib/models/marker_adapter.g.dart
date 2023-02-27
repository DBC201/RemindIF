// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marker_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MarkerAdapterAdapter extends TypeAdapter<MarkerAdapter> {
  @override
  final int typeId = 0;

  @override
  MarkerAdapter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MarkerAdapter(
      title: fields[0] as String,
      latitude: fields[1] as double,
      longtitude: fields[2] as double,
      meterProximity: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MarkerAdapter obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longtitude)
      ..writeByte(3)
      ..write(obj.meterProximity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarkerAdapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
