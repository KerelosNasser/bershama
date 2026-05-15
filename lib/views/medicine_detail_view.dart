import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/medicine_model.dart';
import '../controllers/inventory_controller.dart';
import '../controllers/medicine_controller.dart';

class MedicineDetailView extends StatefulWidget {
  final MedicineModel medicine;

  const MedicineDetailView({super.key, required this.medicine});

  @override
  State<MedicineDetailView> createState() => _MedicineDetailViewState();
}

class _MedicineDetailViewState extends State<MedicineDetailView> {
  late MedicineModel _currentMedicine;

  @override
  void initState() {
    super.initState();
    _currentMedicine = widget.medicine;
  }

  void _refreshMedicine() {
    final medicineController = Get.find<MedicineController>();
    setState(() {
      _currentMedicine = medicineController.medicines.firstWhere(
        (m) => m.id == _currentMedicine.id,
        orElse: () => _currentMedicine,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _currentMedicine.name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              background: Hero(
                tag: 'medicine_${_currentMedicine.id}',
                child: _currentMedicine.imageUrl.isNotEmpty
                    ? Image.network(
                        _currentMedicine.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.medication, size: 100, color: Colors.white),
                        ),
                      )
                    : Container(
                        color: Theme.of(context).primaryColor,
                        child: const Icon(Icons.medication, size: 100, color: Colors.white),
                      ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Chemicals'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _currentMedicine.chemicals
                          .map((c) => Chip(
                                label: Text(c),
                                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              ))
                          .toList(),
                    ),
                    const Divider(height: 32),
                    _buildSectionTitle('Dosage'),
                    const SizedBox(height: 8),
                    Text(_currentMedicine.dosage, style: Theme.of(context).textTheme.bodyLarge),
                    const Divider(height: 32),
                    _buildSectionTitle('Description'),
                    const SizedBox(height: 8),
                    Text(_currentMedicine.description, style: Theme.of(context).textTheme.bodyLarge),
                    const Divider(height: 32),
                    _buildStockSection(context),
                    const SizedBox(height: 80), // Space for button
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _currentMedicine.currentStock > 0 ? () => _showSellDialog(context) : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('SELL MEDICINE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildStockSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle('Current Stock'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _currentMedicine.currentStock > 10 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${_currentMedicine.currentStock} units',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _currentMedicine.currentStock > 10 ? Colors.green : Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showSellDialog(BuildContext context) async {
    final TextEditingController quantityController = TextEditingController(text: '1');
    final inventoryController = Get.find<InventoryController>();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sell Medicine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter quantity for ${_currentMedicine.name}:'),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () async {
              final quantity = int.tryParse(quantityController.text) ?? 0;
              if (quantity <= 0) {
                Get.snackbar('Invalid Quantity', 'Please enter a valid quantity');
                return;
              }
              
              final success = await inventoryController.sellMedicine(_currentMedicine, quantity);
              if (success) {
                _refreshMedicine();
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('SELL'),
          ),
        ],
      ),
    );
  }
}
