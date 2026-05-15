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
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'medicine_${medicine.id}',
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                  ),
                  child: medicine.imageUrl.isNotEmpty
                      ? Image.network(
                          medicine.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.medication, size: 50, color: Colors.blue),
                        )
                      : const Icon(Icons.medication, size: 50, color: Colors.blue),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    medicine.chemicals.join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2,
                        size: 14,
                        color: medicine.currentStock > 10 ? Colors.blue : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${medicine.currentStock}',
                        style: TextStyle(
                          color: medicine.currentStock > 10 ? Colors.blue : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
