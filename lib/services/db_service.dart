import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../models/medicine_model.dart';
import '../models/sale_record.dart';

class DbService extends GetxService {
  late Box<MedicineModel> medicineBox;
  late Box<SaleRecord> saleBox;

  Future<DbService> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MedicineModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(SaleRecordAdapter());
    }
    
    // Open boxes
    medicineBox = await Hive.openBox<MedicineModel>('medicines');
    saleBox = await Hive.openBox<SaleRecord>('sales');
    
    return this;
  }

  // Medicine CRUD
  List<MedicineModel> getMedicines() => medicineBox.values.toList();
  
  Future<void> saveMedicine(MedicineModel medicine) async {
    await medicineBox.put(medicine.id, medicine);
  }

  Future<void> deleteMedicine(String id) async {
    await medicineBox.delete(id);
  }

  // Sales CRUD
  List<SaleRecord> getSales() => saleBox.values.toList();

  Future<void> addSale(SaleRecord sale) async {
    await saleBox.add(sale);
  }
}
