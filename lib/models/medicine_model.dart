import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'medicine_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class MedicineModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> chemicals;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String dosage;

  @HiveField(5)
  final int currentStock;

  @HiveField(6)
  final String imageUrl;

  MedicineModel({
    required this.id,
    required this.name,
    required this.chemicals,
    required this.description,
    required this.dosage,
    required this.currentStock,
    required this.imageUrl,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineModelToJson(this);
}
