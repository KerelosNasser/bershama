import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import '../services/ocr_service.dart';
import '../controllers/medicine_controller.dart';
import '../core/theme.dart';

class OcrScannerController extends GetxController {
  final OcrService _ocrService = Get.find<OcrService>();
  final MedicineController _medicineController = Get.find<MedicineController>();

  CameraController? cameraController;
  var isInitialized = false.obs;
  var isProcessing = false.obs;
  var recognizedText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await cameraController!.initialize();
      isInitialized.value = true;
    } catch (e) {
      Get.snackbar('Camera Error', e.toString());
    }
  }

  Future<void> captureAndProcess() async {
    if (cameraController == null || !cameraController!.value.isInitialized) return;

    isProcessing.value = true;
    try {
      final XFile image = await cameraController!.takePicture();
      final text = await _ocrService.recognizeText(File(image.path));
      recognizedText.value = text.trim();
    } catch (e) {
      Get.snackbar('OCR Error', e.toString());
    } finally {
      isProcessing.value = false;
    }
  }

  void useRecognizedText() {
    if (recognizedText.value.isEmpty) return;
    
    // Take the first line or first few words as a potential medicine name
    final firstLine = recognizedText.value.split('\n').first;
    _medicineController.searchController.text = firstLine;
    _medicineController.searchMedicines(firstLine);
    Get.back();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}

class OcrScannerView extends StatelessWidget {
  const OcrScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OcrScannerController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Scanner'),
      ),
      body: Obx(() {
        if (!controller.isInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(controller.cameraController!),
                  if (controller.isProcessing.value)
                    const CircularProgressIndicator(color: Colors.white),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    Text(
                      'Recognized Text:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          controller.recognizedText.value.isEmpty
                              ? 'Point camera and tap Capture'
                              : controller.recognizedText.value,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.isProcessing.value
                              ? null
                              : controller.captureAndProcess,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Capture'),
                        ),
                        if (controller.recognizedText.value.isNotEmpty)
                          ElevatedButton.icon(
                            onPressed: controller.useRecognizedText,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.check),
                            label: const Text('Use this name'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
