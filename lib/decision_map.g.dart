// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision_map.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DecisionMapAdapter extends TypeAdapter<DecisionMap> {
  @override
  final int typeId = 0;

  @override
  DecisionMap read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DecisionMap()
      ..ID = fields[0] as int
      ..yesID = fields[1] as int
      ..noID = fields[2] as int
      ..description = fields[3] as String
      ..question = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, DecisionMap obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.ID)
      ..writeByte(1)
      ..write(obj.yesID)
      ..writeByte(2)
      ..write(obj.noID)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.question);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DecisionMapAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
