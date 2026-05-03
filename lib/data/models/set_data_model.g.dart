// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SetDataModelAdapter extends TypeAdapter<SetDataModel> {
  @override
  final int typeId = 1;

  @override
  SetDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SetDataModel()
      ..weight = fields[0] as double
      ..reps = fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, SetDataModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.weight)
      ..writeByte(1)
      ..write(obj.reps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
