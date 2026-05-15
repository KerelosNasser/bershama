// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaleRecordAdapter extends TypeAdapter<SaleRecord> {
  @override
  final typeId = 1;

  @override
  SaleRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleRecord(
      medicineId: fields[0] as String,
      quantity: (fields[1] as num).toInt(),
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SaleRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.medicineId)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleRecord _$SaleRecordFromJson(Map<String, dynamic> json) => SaleRecord(
  medicineId: json['medicineId'] as String,
  quantity: (json['quantity'] as num).toInt(),
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$SaleRecordToJson(SaleRecord instance) =>
    <String, dynamic>{
      'medicineId': instance.medicineId,
      'quantity': instance.quantity,
      'timestamp': instance.timestamp.toIso8601String(),
    };
