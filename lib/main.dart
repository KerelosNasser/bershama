import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/db_service.dart';
import 'services/ocr_service.dart';
import 'services/ai_service.dart';
import 'controllers/medicine_controller.dart';
import 'controllers/inventory_controller.dart';
import 'views/home_view.dart';
import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Services
  await Get.putAsync(() => DbService().init());
  Get.put(OcrService());
  Get.put(AiService());

  // Initialize Controllers
  Get.put(MedicineController());
  Get.put(InventoryController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bershama Pharmacy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.pharmacyTheme,
      home: const HomeView(),
    );
  }
}
