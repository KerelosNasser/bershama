import 'package:get/get.dart';
import '../models/medicine_model.dart';
import '../services/db_service.dart';

class MedicineController extends GetxController {
  final DbService _dbService = Get.find<DbService>();

  var medicines = <MedicineModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMedicines();
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
      // Use AppConstants.baseUrl as requested
      // For now, we mock the success response to avoid real network errors in prototype
      // Real implementation would use _dio.get('${AppConstants.baseUrl}/medicines');
      
      // Simulated response delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Example mock data if DB is empty
      if (medicines.isEmpty) {
        final mockData = [
          MedicineModel(
            id: '1',
            name: 'Paracetamol',
            chemicals: ['Acetaminophen'],
            description: 'Pain reliever and fever reducer.',
            dosage: '500mg',
            currentStock: 100,
            imageUrl: 'https://placeholder.com/paracetamol.png',
          ),
          MedicineModel(
            id: '2',
            name: 'Amoxicillin',
            chemicals: ['Amoxicillin'],
            description: 'Antibiotic used to treat bacterial infections.',
            dosage: '250mg',
            currentStock: 50,
            imageUrl: 'https://placeholder.com/amoxicillin.png',
          ),
        ];
        
        for (var med in mockData) {
          await _dbService.saveMedicine(med);
        }
        medicines.assignAll(_dbService.getMedicines());
        _sortMedicines();
      }
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
}
