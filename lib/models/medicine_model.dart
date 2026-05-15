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

  MedicineModel copyWith({
    String? id,
    String? name,
    List<String>? chemicals,
    String? description,
    String? dosage,
    int? currentStock,
    String? imageUrl,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      chemicals: chemicals ?? this.chemicals,
      description: description ?? this.description,
      dosage: dosage ?? this.dosage,
      currentStock: currentStock ?? this.currentStock,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory MedicineModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineModelToJson(this);
}
