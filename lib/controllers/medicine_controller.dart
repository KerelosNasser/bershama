import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/medicine_model.dart';
import '../services/db_service.dart';

class MedicineController extends GetxController {
  final DbService _dbService = Get.find<DbService>();
  final searchController = TextEditingController();

  var medicines = <MedicineModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMedicines();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadMedicines() async {
    isLoading.value = true;
    try {
      // 1. Load from Local DB
      final localMedicines = _dbService.getMedicines();
      medicines.assignAll(localMedicines);
      _sortMedicines();

      // 2. Mock API Call
      await _fetchFromApi();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchFromApi() async {
    try {
      // Simulated response delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mocking 100+ items for educational optimization
      final List<MedicineModel> mockData = List.generate(110, (index) {
        final prefixes = ['Panadol', 'Augmentin', 'Brufen', 'Cataflam', 'Zyrtec', 'Congestal', 'Antinal', 'Motilium'];
        final name = '${prefixes[index % prefixes.length]} ${100 + index}';
        return MedicineModel(
          id: 'mock_$index',
          name: name,
          chemicals: ['Chemical X', 'Compound Y'],
          description: 'Educational description for $name. This medicine is used to demonstrate GridView.builder optimization.',
          dosage: '${(index % 3) + 1} tablet daily',
          currentStock: 10 + (index % 50),
          imageUrl: 'https://picsum.photos/seed/${index + 100}/200',
        );
      });
      
      for (var med in mockData) {
        await _dbService.saveMedicine(med);
      }
      medicines.assignAll(_dbService.getMedicines());
      _sortMedicines();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch from API: $e');
    }
  }

  void searchMedicines(String query) {
    if (query.isEmpty) {
      medicines.assignAll(_dbService.getMedicines());
    } else {
      final filtered = _dbService.getMedicines().where((m) =>
          m.name.toLowerCase().contains(query.toLowerCase()) ||
          m.chemicals.any((c) => c.toLowerCase().contains(query.toLowerCase()))).toList();
      medicines.assignAll(filtered);
    }
    _sortMedicines();
  }

  void _sortMedicines() {
    medicines.sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> addMedicine(MedicineModel medicine) async {
    await _dbService.saveMedicine(medicine);
    medicines.add(medicine);
    _sortMedicines();
  }

  Future<void> updateMedicine(MedicineModel medicine) async {
    await _dbService.saveMedicine(medicine);
    final index = medicines.indexWhere((m) => m.id == medicine.id);
    if (index != -1) {
      medicines[index] = medicine;
    }
  }

  Future<void> deleteMedicine(String id) async {
    await _dbService.deleteMedicine(id);
    medicines.removeWhere((m) => m.id == id);
  }
}
