import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/medicine_controller.dart';
import '../models/medicine_model.dart';

class AdminView extends GetView<MedicineController> {
  const AdminView({super.key});

  void _showMedicineDialog({MedicineModel? medicine}) {
    final isEdit = medicine != null;
    final nameController = TextEditingController(text: medicine?.name ?? '');
    final chemicalsController = TextEditingController(text: medicine?.chemicals.join(', ') ?? '');
    final descController = TextEditingController(text: medicine?.description ?? '');
    final stockController = TextEditingController(text: medicine?.currentStock.toString() ?? '0');

    Get.dialog(
      AlertDialog(
        title: Text(isEdit ? 'Edit Medicine' : 'Add Medicine'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: chemicalsController, decoration: const InputDecoration(labelText: 'Chemicals (comma separated)')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: stockController, decoration: const InputDecoration(labelText: 'Stock'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newMed = MedicineModel(
                id: medicine?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text,
                chemicals: chemicalsController.text.split(',').map((e) => e.trim()).toList(),
                description: descController.text,
                dosage: medicine?.dosage ?? 'As directed',
                currentStock: int.tryParse(stockController.text) ?? 0,
                imageUrl: medicine?.imageUrl ?? 'https://picsum.photos/200',
              );
              
              if (isEdit) {
                await controller.updateMedicine(newMed);
              } else {
                await controller.addMedicine(newMed);
              }
              Get.back();
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Inventory')),
      body: Obx(() => ListView.builder(
            itemCount: controller.medicines.length,
            itemBuilder: (context, index) {
              final med = controller.medicines[index];
              return ListTile(
                title: Text(med.name),
                subtitle: Text('Stock: ${med.currentStock}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showMedicineDialog(medicine: med)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => controller.deleteMedicine(med.id)),
                  ],
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMedicineDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
