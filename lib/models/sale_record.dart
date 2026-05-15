import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sale_record.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class SaleRecord extends HiveObject {
  @HiveField(0)
  final String medicineId;

  @HiveField(1)
  final int quantity;

  @HiveField(2)
  final DateTime timestamp;

  SaleRecord({
    required this.medicineId,
    required this.quantity,
    required this.timestamp,
  });

  factory SaleRecord.fromJson(Map<String, dynamic> json) =>
      _$SaleRecordFromJson(json);

  Map<String, dynamic> toJson() => _$SaleRecordToJson(this);
}
