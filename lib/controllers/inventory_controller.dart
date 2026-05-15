import 'package:get/get.dart';
import '../models/medicine_model.dart';
import '../models/sale_record.dart';
import '../services/db_service.dart';
import 'medicine_controller.dart';

class InventoryController extends GetxController {
  final DbService _dbService = Get.find<DbService>();
  final MedicineController _medicineController = Get.find<MedicineController>();

  Future<bool> sellMedicine(MedicineModel medicine, int quantity) async {
    if (medicine.currentStock < quantity) {
      Get.snackbar('Out of Stock', 'Not enough units for ${medicine.name}');
      return false;
    }

    try {
      // 1. Decrease stock
      final updatedMedicine = medicine.copyWith(
        currentStock: medicine.currentStock - quantity,
      );

      // 2. Add SaleRecord
      final sale = SaleRecord(
        medicineId: medicine.id,
        quantity: quantity,
        timestamp: DateTime.now(),
      );

      // 3. Update DB and UI State
      await _medicineController.updateMedicine(updatedMedicine);
      await _dbService.addSale(sale);

      Get.snackbar(
        'Success', 
        'Sold $quantity units of ${medicine.name}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to process sale: $e');
      return false;
    }
  }

  Future<void> updateStock(MedicineModel medicine, int newStock) async {
    try {
      final updatedMedicine = medicine.copyWith(currentStock: newStock);
      await _dbService.saveMedicine(updatedMedicine);
      await _medicineController.loadMedicines();
      Get.snackbar('Updated', '${medicine.name} stock updated to $newStock');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update stock: $e');
    }
  }
}
