import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/medicine_model.dart';
import '../services/db_service.dart';

class MedicineController extends GetxController {
  final DbService _dbService = Get.find<DbService>();
  final searchController = TextEditingController();

  var medicines = <MedicineModel>[].obs;
  var isLoading = false.obs;
  var selectedLetter = ''.obs;
  var currentSort = 'A to Z'.obs;

  final List<String> sortOptions = [
    'A to Z',
    'Z to A',
    'Most Frequently Bought',
    'Recently Added'
  ];

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
      final localMedicines = _dbService.getMedicines();
      medicines.assignAll(localMedicines);
      _sortMedicines();

      await _fetchFromApi();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchFromApi() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final List<MedicineModel> mockData = List.generate(110, (index) {
        final prefixes = ['Panadol', 'Augmentin', 'Brufen', 'Cataflam', 'Zyrtec', 'Congestal', 'Antinal', 'Motilium'];
        final name = '${prefixes[index % prefixes.length]} ${100 + index}';
        return MedicineModel(
          id: 'mock_$index',
          name: name,
          chemicals: ['Chemical X', 'Compound Y'],
          description: 'Educational description for $name.',
          dosage: '${(index % 3) + 1} tablet daily',
          currentStock: 10 + (index % 50),
          imageUrl: 'https://picsum.photos/seed/${index + 100}/200',
        );
      });
      
      for (var med in mockData) {
        await _dbService.saveMedicine(med);
      }
      _refreshList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch from API: $e');
    }
  }

  void filterByLetter(String letter) {
    if (selectedLetter.value == letter) {
      selectedLetter.value = '';
    } else {
      selectedLetter.value = letter;
    }
    _refreshList();
  }

  void searchMedicines(String query) {
    _refreshList();
  }

  void applySorting(String sortType) {
    currentSort.value = sortType;
    _sortMedicines();
  }

  void _refreshList() {
    var list = _dbService.getMedicines();
    
    if (searchController.text.isNotEmpty) {
      final query = searchController.text.toLowerCase();
      list = list.where((m) =>
          m.name.toLowerCase().contains(query) ||
          m.chemicals.any((c) => c.toLowerCase().contains(query))).toList();
    }

    if (selectedLetter.value.isNotEmpty) {
      list = list.where((m) => m.name.toUpperCase().startsWith(selectedLetter.value)).toList();
    }

    medicines.assignAll(list);
    _sortMedicines();
  }

  void _sortMedicines() {
    switch (currentSort.value) {
      case 'A to Z':
        medicines.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Z to A':
        medicines.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Most Frequently Bought':
        final sales = _dbService.saleBox.values.toList();
        final salesCount = <String, int>{};
        for (var sale in sales) {
          salesCount[sale.medicineId] = (salesCount[sale.medicineId] ?? 0) + sale.quantity;
        }
        medicines.sort((a, b) => (salesCount[b.id] ?? 0).compareTo(salesCount[a.id] ?? 0));
        break;
      case 'Recently Added':
        medicines.sort((a, b) => b.id.compareTo(a.id));
        break;
    }
  }

  Future<void> addMedicine(MedicineModel medicine) async {
    await _dbService.saveMedicine(medicine);
    _refreshList();
  }

  Future<void> updateMedicine(MedicineModel medicine) async {
    await _dbService.saveMedicine(medicine);
    final index = medicines.indexWhere((m) => m.id == medicine.id);
    if (index != -1) {
      medicines[index] = medicine;
      medicines.refresh(); // Trigger Obx listeners for list elements
    }
  }

  Future<void> deleteMedicine(String id) async {
    await _dbService.deleteMedicine(id);
    _refreshList();
  }
}
