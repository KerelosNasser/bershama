import 'package:flutter/material.dart';
import '../../models/medicine_model.dart';

class MedicineTile extends StatelessWidget {
  final MedicineModel medicine;
  final VoidCallback onTap;

  const MedicineTile({
    super.key,
    required this.medicine,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: Hero(
          tag: 'medicine_${medicine.id}',
          child: medicine.imageUrl.isNotEmpty
              ? Image.network(
                  medicine.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.medication, size: 50),
                )
              : const Icon(Icons.medication, size: 50),
        ),
        title: Text(
          medicine.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medicine.chemicals.join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.inventory_2,
                  size: 14,
                  color: medicine.currentStock > 10 ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  'Stock: ${medicine.currentStock}',
                  style: TextStyle(
                    color: medicine.currentStock > 10 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
