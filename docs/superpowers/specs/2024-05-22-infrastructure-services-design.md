# Infrastructure Services Design

**Goal:** Implement core services for Bershama app: Local Database (Hive), OCR (Text Recognition), and AI (OpenRouter).

## Architecture
Services will be implemented as `GetxService` classes to ensure they stay in memory throughout the app lifecycle. They will be registered during app initialization.

## Components

### 1. DbService (`lib/services/db_service.dart`)
- **Responsibilities:**
    - Initialize Hive and Hive-Flutter.
    - Register TypeAdapters for `MedicineModel` and `SaleRecord`.
    - Open boxes: `medicines` and `sales_records`.
    - Provide CRUD methods for medicines and sales.
- **Methods:**
    - `Future<void> init()`
    - `List<MedicineModel> getAllMedicines()`
    - `Future<void> saveMedicine(MedicineModel medicine)`
    - `Future<void> deleteMedicine(String id)`
    - `List<SaleRecord> getAllSales()`
    - `Future<void> addSale(SaleRecord sale)`

### 2. OcrService (`lib/services/ocr_service.dart`)
- **Responsibilities:**
    - Wrap `google_mlkit_text_recognition`.
    - Extract text from image files.
- **Methods:**
    - `Future<String> recognizeText(File image)`

### 3. AiService (`lib/services/ai_service.dart`)
- **Responsibilities:**
    - Call OpenRouter API using `Dio`.
    - Provide pharmaceutical advice based on inputs.
- **Methods:**
    - `Future<String> getMedicalAdvice(String query)`
- **System Prompt:**
    - "You are a professional pharmacist assistant for the Bershama app. Provide concise, accurate medical advice based on the medicine or symptoms provided. Always include a disclaimer to consult a doctor."

## Guidelines (`lib/services/GEMINI.md`)
- Use singleton pattern via GetX.
- Minimal error handling: focus on critical failures.
- Async methods for I/O operations.

## Testing Strategy
- Mocking: Use `mockito` or `mocktail` for `Dio` and `TextRecognizer`.
- Unit tests for each service method.
