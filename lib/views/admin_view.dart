import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import '../controllers/medicine_controller.dart';
import '../controllers/inventory_controller.dart';
import '../models/medicine_model.dart';

class AdminView extends GetView<MedicineController> {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final invController = Get.find<InventoryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('Inventory Dashboard'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsSection(invController),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Medicine Records',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showMedicineDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add New'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMedicineGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(InventoryController invController) {
    return Row(
      children: [
        _buildStatCard(
          'Total Stock',
          '${controller.medicines.fold(0, (sum, item) => sum + item.currentStock)}',
          HeroIcons.archiveBox,
          Colors.blue,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          'Low Stock',
          '${controller.medicines.where((m) => m.currentStock < 10).length}',
          HeroIcons.exclamationTriangle,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, HeroIcons icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroIcon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineGrid() {
    return Obx(() => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: 100,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.medicines.length,
          itemBuilder: (context, index) {
            final med = controller.medicines[index];
            return _buildInventoryItem(med);
          },
        ));
  }

  Widget _buildInventoryItem(MedicineModel med) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: HeroIcon(HeroIcons.beaker, color: Colors.blue)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Stock: ${med.currentStock} units', 
                     style: TextStyle(color: med.currentStock < 10 ? Colors.red : Colors.grey[600])),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const HeroIcon(HeroIcons.pencilSquare, size: 20, color: Colors.blue),
                onPressed: () => _showMedicineDialog(medicine: med),
              ),
              IconButton(
                icon: const HeroIcon(HeroIcons.trash, size: 20, color: Colors.red),
                onPressed: () => controller.deleteMedicine(med.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMedicineDialog({MedicineModel? medicine}) {
    final isEdit = medicine != null;
    final nameController = TextEditingController(text: medicine?.name ?? '');
    final chemicalsController = TextEditingController(text: medicine?.chemicals.join(', ') ?? '');
    final descController = TextEditingController(text: medicine?.description ?? '');
    final stockController = TextEditingController(text: medicine?.currentStock.toString() ?? '0');

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEdit ? 'Update Medicine' : 'Add New Entry',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                  prefixIcon: const Padding(padding: EdgeInsets.all(12), child: HeroIcon(HeroIcons.tag)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: chemicalsController,
                decoration: InputDecoration(
                  labelText: 'Active Chemicals',
                  prefixIcon: const Padding(padding: EdgeInsets.all(12), child: HeroIcon(HeroIcons.beaker)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Full Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Initial Stock Count',
                  prefixIcon: const Padding(padding: EdgeInsets.all(12), child: HeroIcon(HeroIcons.archiveBox)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final newMed = MedicineModel(
                      id: medicine?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      chemicals: chemicalsController.text.split(',').map((e) => e.trim()).toList(),
                      description: descController.text,
                      dosage: medicine?.dosage ?? 'As directed by physician',
                      currentStock: int.tryParse(stockController.text) ?? 0,
                      imageUrl: medicine?.imageUrl ?? 'https://picsum.photos/seed/${nameController.text}/200',
                    );
                    
                    if (isEdit) {
                      await controller.updateMedicine(newMed);
                    } else {
                      await controller.addMedicine(newMed);
                    }
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(Get.context!).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(isEdit ? 'Apply Changes' : 'Create Record'),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
