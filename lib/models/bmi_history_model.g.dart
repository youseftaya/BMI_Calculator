// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bmi_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BmiHistoryModelAdapter extends TypeAdapter<BmiHistoryModel> {
  @override
  final int typeId = 0;

  @override
  BmiHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BmiHistoryModel(
      bmi: fields[0] as double,
      result: fields[1] as String,
      interpretation: fields[2] as String,
      age: fields[3] as int,
      weight: fields[4] as int,
      height: fields[5] as double,
      isMale: fields[6] as bool,
      date: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BmiHistoryModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.bmi)
      ..writeByte(1)
      ..write(obj.result)
      ..writeByte(2)
      ..write(obj.interpretation)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.height)
      ..writeByte(6)
      ..write(obj.isMale)
      ..writeByte(7)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BmiHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
