// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineModelAdapter extends TypeAdapter<MedicineModel> {
  @override
  final typeId = 0;

  @override
  MedicineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineModel(
      id: fields[0] as String,
      name: fields[1] as String,
      chemicals: (fields[2] as List).cast<String>(),
      description: fields[3] as String,
      dosage: fields[4] as String,
      currentStock: (fields[5] as num).toInt(),
      imageUrl: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.chemicals)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.dosage)
      ..writeByte(5)
      ..write(obj.currentStock)
      ..writeByte(6)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineModel _$MedicineModelFromJson(Map<String, dynamic> json) =>
    MedicineModel(
      id: json['id'] as String,
      name: json['name'] as String,
      chemicals: (json['chemicals'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String,
      dosage: json['dosage'] as String,
      currentStock: (json['currentStock'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$MedicineModelToJson(MedicineModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'chemicals': instance.chemicals,
      'description': instance.description,
      'dosage': instance.dosage,
      'currentStock': instance.currentStock,
      'imageUrl': instance.imageUrl,
    };
