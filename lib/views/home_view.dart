import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/medicine_controller.dart';
import 'widgets/medicine_tile.dart';
import 'medicine_detail_view.dart';

class HomeView extends GetView<MedicineController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bershama Pharmacy'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: controller.searchMedicines,
              decoration: InputDecoration(
                hintText: 'Search medicines or chemicals...',
                prefixIcon: const Icon(Icons.search),
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
          child: ListView.builder(
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
