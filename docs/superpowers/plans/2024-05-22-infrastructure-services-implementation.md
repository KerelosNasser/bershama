# Infrastructure Services Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement `DbService`, `OcrService`, and `AiService` for data persistence, text recognition, and AI-powered medical advice.

**Architecture:** GetX Services for singleton management. Hive for local storage. Dio for HTTP requests. Google ML Kit for OCR.

**Tech Stack:** Flutter, GetX, Hive, Dio, Google ML Kit Text Recognition.

---

### Task 1: Service Guidelines

**Files:**
- Create: `lib/services/GEMINI.md`

- [ ] **Step 1: Create `lib/services/GEMINI.md`**

```markdown
# Bershama Service Guidelines

## Singleton Pattern
- All services MUST extend `GetxService`.
- Services are initialized once at app start.
- Access services using `Get.find<T>()`.

## Error Handling
- Focus on critical failures (e.g., DB initialization failure, network timeout).
- Use `try-catch` blocks in service methods.
- Log errors to console (or a logging service if available).
- Return meaningful defaults or rethrow if necessary.

## Best Practices
- Keep services focused on a single responsibility.
- Use `Dio` for all network requests in `AiService`.
- Use `Hive` for all local storage in `DbService`.
```

- [ ] **Step 2: Commit**

```bash
rtk git add lib/services/GEMINI.md
rtk git commit -m "docs: add service guidelines"
```

### Task 2: Implement `DbService`

**Files:**
- Create: `lib/services/db_service.dart`

- [ ] **Step 1: Implement `DbService`**

```dart
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../models/medicine_model.dart';
import '../models/sale_record.dart';

class DbService extends GetxService {
  late Box<MedicineModel> medicineBox;
  late Box<SaleRecord> saleBox;

  Future<DbService> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(MedicineModelAdapter());
    Hive.registerAdapter(SaleRecordAdapter());
    
    // Open boxes
    medicineBox = await Hive.openBox<MedicineModel>('medicines');
    saleBox = await Hive.openBox<SaleRecord>('sales');
    
    return this;
  }

  // Medicine CRUD
  List<MedicineModel> getMedicines() => medicineBox.values.toList();
  
  Future<void> saveMedicine(MedicineModel medicine) async {
    await medicineBox.put(medicine.id, medicine);
  }

  Future<void> deleteMedicine(String id) async {
    await medicineBox.delete(id);
  }

  // Sales CRUD
  List<SaleRecord> getSales() => saleBox.values.toList();

  Future<void> addSale(SaleRecord sale) async {
    await saleBox.add(sale);
  }
}
```

- [ ] **Step 2: Commit**

```bash
rtk git add lib/services/db_service.dart
rtk git commit -m "feat: implement DbService"
```

### Task 3: Implement `OcrService`

**Files:**
- Create: `lib/services/ocr_service.dart`

- [ ] **Step 1: Implement `OcrService`**

```dart
import 'dart:io';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService extends GetxService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<String> recognizeText(File image) async {
    final inputImage = InputImage.fromFile(image);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  @override
  void onClose() {
    _textRecognizer.close();
    super.onClose();
  }
}
```

- [ ] **Step 2: Commit**

```bash
rtk git add lib/services/ocr_service.dart
rtk git commit -m "feat: implement OcrService"
```

### Task 4: Implement `AiService`

**Files:**
- Create: `lib/services/ai_service.dart`

- [ ] **Step 1: Implement `AiService`**

```dart
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AiService extends GetxService {
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://openrouter.ai/api/v1',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer YOUR_OPENROUTER_API_KEY', // Should be moved to env/config
    },
  ));

  Future<String> getMedicalAdvice(String symptoms) async {
    try {
      final response = await _dio.post('/chat/completions', data: {
        'model': 'google/gemini-2.0-flash-001',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a professional pharmacist assistant for the Bershama app. Provide concise, accurate medical advice based on symptoms. Always advise consulting a real doctor.'
          },
          {'role': 'user', 'content': 'Symptoms: $symptoms'}
        ],
      });

      return response.data['choices'][0]['message']['content'];
    } catch (e) {
      return 'Error fetching advice. Please try again later.';
    }
  }
}
```

- [ ] **Step 2: Commit**

```bash
rtk git add lib/services/ai_service.dart
rtk git commit -m "feat: implement AiService"
```

### Task 5: Register Services

**Files:**
- Modify: `lib/main.dart`

- [ ] **Step 1: Initialize services in `main()`**

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'lib/services/db_service.dart';
import 'lib/services/ocr_service.dart';
import 'lib/services/ai_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Services
  await Get.putAsync(() => DbService().init());
  Get.put(OcrService());
  Get.put(AiService());
  
  runApp(const MyApp());
}
```

- [ ] **Step 2: Commit**

```bash
rtk git add lib/main.dart
rtk git commit -m "feat: register infrastructure services"
```
