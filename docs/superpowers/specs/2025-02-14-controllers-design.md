# Medicine & Inventory Controllers Design

## 1. MedicineController
Responsible for managing the list of medicines, searching, and fetching data.

### State
- `RxList<MedicineModel> allMedicines`: Full list of medicines from DB.
- `RxList<MedicineModel> filteredMedicines`: List used for display, updated by search.
- `RxBool isLoading`: Loading state for UI feedback.

### Key Logic
- `onInit`: Call `fetchMedicines`.
- `fetchMedicines`: Get from `DbService`, sort A-Z, update `allMedicines` and `filteredMedicines`.
- `search(String query)`: Filter `allMedicines` by name/chemicals and update `filteredMedicines`.
- `fetchExternalInfo(String name)`: Use `AiService` or `Dio` to get extra info if needed.

## 2. InventoryController
Responsible for stock management and sales transactions.

### Key Logic
- `sellMedicine(MedicineModel medicine, int quantity)`:
    - Validate stock.
    - Create `SaleRecord`.
    - Update `MedicineModel` with decreased `currentStock`.
    - Save both to `DbService`.
    - Trigger `MedicineController.fetchMedicines` to refresh UI if needed (or update the list in-place).
- `updateStock(MedicineModel medicine, int newStock)`:
    - Update `currentStock`.
    - Save to `DbService`.

## 3. GEMINI.md Guidelines
- Use `onInit` for data fetching.
- Use `onClose` for resource cleanup.
- Prefer `Obx` for reactive state.
- No UI code in controllers.
