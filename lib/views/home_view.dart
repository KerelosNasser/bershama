import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import '../controllers/medicine_controller.dart';
import 'widgets/medicine_tile.dart';
import 'medicine_detail_view.dart';
import 'ai_help_view.dart';
import 'ocr_scanner_view.dart';

class HomeView extends GetView<MedicineController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bershama Pharmacy',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: [
          IconButton(
            icon: const HeroIcon(HeroIcons.camera),
            onPressed: () => Get.to(() => const OcrScannerView()),
            tooltip: 'OCR Scanner',
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.searchMedicines,
              decoration: InputDecoration(
                hintText: 'Search medicines or chemicals...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.searchMedicines('');
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.medicines.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.medicines.isEmpty) {
          return const Center(child: Text('No medicines found.'));
        }

        return RefreshIndicator(
          onRefresh: controller.loadMedicines,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: controller.medicines.length,
            itemBuilder: (context, index) {
              final medicine = controller.medicines[index];
              return MedicineTile(
                medicine: medicine,
                onTap: () => Get.to(() => MedicineDetailView(medicine: medicine)),
              );
            },
          ),
        );
      }),
    );
  }
}
