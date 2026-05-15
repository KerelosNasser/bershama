import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/medicine_model.dart';
import '../controllers/inventory_controller.dart';
import '../controllers/medicine_controller.dart';
import '../core/theme.dart';

class MedicineDetailView extends GetView<MedicineController> {
  final MedicineModel medicine;

  const MedicineDetailView({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Obx(() {
        // Find the latest state of this medicine from the controller
        final currentMed = controller.medicines.firstWhere(
          (m) => m.id == medicine.id,
          orElse: () => medicine,
        );

        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(currentMed),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickStats(currentMed),
                    const SizedBox(height: 32),
                    _buildInfoSection(
                      'Clinical Mechanism',
                      currentMed.description,
                      HeroIcons.beaker,
                      Colors.blue,
                    ),
                    const SizedBox(height: 20),
                    _buildInfoSection(
                      'Recommended Dosage',
                      currentMed.dosage,
                      HeroIcons.clock,
                      Colors.indigo,
                    ),
                    const SizedBox(height: 20),
                    _buildChemicalsSection(currentMed),
                    const SizedBox(height: 20),
                    _buildProfessionalNotes(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
        final currentMed = controller.medicines.firstWhere(
          (m) => m.id == medicine.id,
          orElse: () => medicine,
        );
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: FloatingActionButton.extended(
              onPressed: currentMed.currentStock > 0 ? () => _showSellDialog(context, currentMed) : null,
              backgroundColor: currentMed.currentStock > 0 ? AppTheme.primaryBlue : Colors.grey,
              elevation: 4,
              label: const Text(
                'ISSUE MEDICATION',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1),
              ),
              icon: const HeroIcon(HeroIcons.shoppingCart, size: 20),
            ),
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 1);
      }),
    );
  }

  Widget _buildSliverAppBar(MedicineModel med) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppTheme.primaryBlue,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'medicine_${med.id}',
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                ),
                child: med.imageUrl.isNotEmpty
                    ? Image.network(
                        med.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: HeroIcon(HeroIcons.beaker, size: 80, color: AppTheme.primaryBlue),
                        ),
                      )
                    : const Center(child: HeroIcon(HeroIcons.beaker, size: 80, color: AppTheme.primaryBlue)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    med.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'PHARMACEUTICAL GRADE PRODUCT',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(MedicineModel med) {
    return Row(
      children: [
        _buildStatTile('STATUS', med.currentStock > 0 ? 'AVAILABLE' : 'OUT OF STOCK', 
                       med.currentStock > 0 ? Colors.green : Colors.red),
        const SizedBox(width: 12),
        _buildStatTile('STOCK', '${med.currentStock} UNITS', AppTheme.primaryBlue),
      ],
    ).animate().fadeIn(delay: 200.ms).slideX();
  }

  Widget _buildStatTile(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, HeroIcons icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HeroIcon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildChemicalsSection(MedicineModel med) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              HeroIcon(HeroIcons.fire, color: Colors.orange, size: 24),
              const SizedBox(width: 12),
              Text('Active Ingredients', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: med.chemicals.map((c) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.2)),
              ),
              child: Text(
                c,
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalNotes() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.1)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HeroIcon(HeroIcons.academicCap, color: AppTheme.primaryBlue, size: 24),
              const SizedBox(width: 12),
              Text('Pharmacist Notes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Keep in a cool, dry place away from children. Monitor patient for allergic reactions especially if prescribed with other antibiotics.',
            style: TextStyle(fontSize: 14, color: AppTheme.primaryBlue, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Future<void> _showSellDialog(BuildContext context, MedicineModel med) async {
    final TextEditingController quantityController = TextEditingController(text: '1');
    final inventoryController = Get.find<InventoryController>();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Issue Medication', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Enter amount to remove from stock for ${med.name}.', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 24),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Quantity',
                prefixIcon: const Padding(padding: EdgeInsets.all(12), child: HeroIcon(HeroIcons.hashtag)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  final quantity = int.tryParse(quantityController.text) ?? 0;
                  if (quantity <= 0) return;
                  
                  final success = await inventoryController.sellMedicine(med, quantity);
                  if (success) {
                    Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('CONFIRM TRANSACTION', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
