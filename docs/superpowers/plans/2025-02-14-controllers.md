# Controllers Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement GetX controllers for medicine management and inventory/sales logic.

**Architecture:** Reactive state management using GetX. Controllers interact with `DbService` for persistence and `AiService` for external data.

**Tech Stack:** Flutter, GetX, Hive, Dio.

---

### Task 1: Controller Guidelines

**Files:**
- Create: `lib/controllers/GEMINI.md`

- [ ] **Step 1: Create guidelines file**

Write to `lib/controllers/GEMINI.md`:
```markdown
# Controllers Guidelines

- Use `onInit` for initial data fetching and state setup.
- Use `onClose` for cleaning up controllers, closing streams, or disposing controllers.
- Use `Rx` variables for reactive state.
- Use `Obx` in the UI to react to changes.
- Controllers must focus on business logic and state management.
- DO NOT put UI code or direct context-dependent code in controllers.
```

- [ ] **Step 2: Commit**

```bash
rtk git add lib/controllers/GEMINI.md
rtk git commit -m "docs: add controller guidelines"
```

---

### Task 2: MedicineController

**Files:**
- Create: `lib/controllers/medicine_controller.dart`
- Create: `test/controllers/medicine_controller_test.dart`

- [ ] **Step 1: Create MedicineController**

```dart
import 'package:get/get.dart';
import '../models/medicine_model.dart';
import '../services/db_service.dart';
import '../services/ai_service.dart';

class MedicineController extends GetxController {
  final DbService _db = Get.find<DbService>();
  final AiService _ai = Get.find<AiService>();

  final allMedicines = <MedicineModel>[].obs;
  final filteredMedicines = <MedicineModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMedicines();
  }

  void fetchMedicines() {
    isLoading.value = true;
    final list = _db.getMedicines();
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    allMedicines.assignAll(list);
    filteredMedicines.assignAll(list);
    isLoading.value = false;
  }

  void searchMedicines(String query) {
    if (query.isEmpty) {
      filteredMedicines.assignAll(allMedicines);
    } else {
      final q = query.toLowerCase();
      filteredMedicines.assignAll(
        allMedicines.where((m) =>
          m.name.toLowerCase().contains(q) ||
          m.chemicals.any((c) => c.toLowerCase().contains(q))
        ).toList(),
      );
    }
  }

  Future<String> getAdvice(String name) async {
    return await _ai.getMedicalAdvice("Tell me about $name");
  }
}
```

- [ ] **Step 2: Commit**

```bash
rtk git add lib/controllers/medicine_controller.dart
rtk git commit -m "feat: add MedicineController"
```

---

### Task 3: InventoryController

**Files:**
- Create: `lib/controllers/inventory_controller.dart`

- [ ] **Step 1: Create InventoryController**

```dart
import 'package:get/get.dart';
import '../models/medicine_model.dart';
import '../models/sale_record.dart';
import '../services/db_service.dart';
import 'medicine_controller.dart';

class InventoryController extends GetxController {
  final DbService _db = Get.find<DbService>();

  Future<void> sellMedicine(MedicineModel medicine, int quantity) async {
    if (medicine.currentStock < quantity) {
      Get.snackbar("Error", "Not enough stock");
      return;
    }

    final updatedMedicine = MedicineModel(
      id: medicine.id,
      name: medicine.name,
      chemicals: medicine.chemicals,
      description: medicine.description,
      dosage: medicine.dosage,
      currentStock: medicine.currentStock - quantity,
      imageUrl: medicine.imageUrl,
    );

    await _db.saveMedicine(updatedMedicine);
    await _db.addSale(SaleRecord(
      medicineId: medicine.id,
      quantity: quantity,
      timestamp: DateTime.now(),
    ));

    // Refresh medicine list
    if (Get.isRegistered<MedicineController>()) {
      Get.find<MedicineController>().fetchMedicines();
    }
  }

  Future<void> updateStock(MedicineModel medicine, int newStock) async {
    final updatedMedicine = MedicineModel(
      id: medicine.id,
      name: medicine.name,
      chemicals: medicine.chemicals,
      description: medicine.description,
      dosage: medicine.dosage,
      currentStock: newStock,
      imageUrl: medicine.imageUrl,
    );

    await _db.saveMedicine(updatedMedicine);
    
    if (Get.isRegistered<MedicineController>()) {
      Get.find<MedicineController>().fetchMedicines();
    }
  }
}
```

- [ ] **Step 2: Commit**

```bash
rtk git add lib/controllers/inventory_controller.dart
rtk git commit -m "feat: add InventoryController"
```

---

### Task 4: Final Verification

- [ ] **Step 1: Check project compilation**

Run: `flutter pub get`
Expected: SUCCESS

- [ ] **Step 2: Verify files exist**

Run: `rtk proxy dir /s /b lib\controllers`
Expected: List of files including GEMINI.md, medicine_controller.dart, inventory_controller.dart.

- [ ] **Step 3: Final Commit**

```bash
rtk git add .
rtk git commit -m "feat: implement Task 4 controllers"
```
