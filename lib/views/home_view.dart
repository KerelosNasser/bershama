import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import '../controllers/medicine_controller.dart';
import '../core/theme.dart';
import 'widgets/medicine_tile.dart';
import 'medicine_detail_view.dart';
import 'ocr_scanner_view.dart';

class HomeView extends GetView<MedicineController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Bershama Pharmacy',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: [
          _buildSortDropdown(),
          IconButton(
            icon: const HeroIcon(HeroIcons.camera),
            onPressed: () => Get.to(() => const OcrScannerView()),
            tooltip: 'OCR Scanner',
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              _buildLetterBar(),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.medicines.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.medicines.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeroIcon(HeroIcons.magnifyingGlass, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text('No medicines found.', style: TextStyle(color: Colors.grey, fontSize: 18)),
              ],
            ),
          );
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

  Widget _buildSortDropdown() {
    return PopupMenuButton<String>(
      icon: const HeroIcon(HeroIcons.barsArrowDown),
      onSelected: controller.applySorting,
      itemBuilder: (context) => controller.sortOptions
          .map((opt) => PopupMenuItem(
                value: opt,
                child: Obx(() => Row(
                      children: [
                        if (controller.currentSort.value == opt)
                          const Icon(Icons.check, size: 18, color: AppTheme.primaryBlue),
                        const SizedBox(width: 8),
                        Text(
                          opt,
                          style: TextStyle(
                            color: controller.currentSort.value == opt ? AppTheme.primaryBlue : Colors.black87,
                            fontWeight: controller.currentSort.value == opt ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    )),
              ))
          .toList(),
    );
  }

  Widget _buildLetterBar() {
    final letters = List.generate(26, (i) => String.fromCharCode(65 + i));
    return Container(
      height: 50,
      padding: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: letters.length,
        itemBuilder: (context, index) {
          final letter = letters[index];
          return Obx(() {
            final isSelected = controller.selectedLetter.value == letter;
            return GestureDetector(
              onTap: () => controller.filterByLetter(letter),
              child: Container(
                width: 36,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: isSelected ? AppTheme.primaryBlue : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
