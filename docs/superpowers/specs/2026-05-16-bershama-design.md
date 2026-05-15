# Bershama App Design Specification

## Status: Approved
## Date: 2026-05-16
## Stack: Flutter, GetX, Dio, Hive, OpenRouter, Google ML Kit

## Context
Educational project for pharmacy students. Goal: Teach Flutter basics, state management, API/AI integration, OCR, and local database usage. "Bershama" (Arabic wordplay for drugs/meds) focuses on medicine categorization, OCR-based recognition, AI diagnostic assistance, and inventory tracking.

## Architecture: Classic MVC (Clean)
Standard MVC pattern with strict file size limits (< 500 lines) and clear responsibility separation.

### Folder Structure
- `lib/core/`: Constants, themes, API config, AI prompt templates.
- `lib/models/`: `Medicine`, `SaleRecord`, `StockUpdate` (JSON serializable).
- `lib/views/`: Screen-level UI. Sub-folders for complex widgets.
- `lib/controllers/`: GetxControllers (State + logic).
- `lib/services/`: Hive storage, OCR engine, OpenRouter client.
- `lib/routes/`: App pages and Bindings.

## Functional Requirements
- **FR-1: A-Z Categorization**: Main screen must list medicines alphabetically.
- **FR-2: Search & Filter**: Search bar for medicine names.
- **FR-3: Medicine Details**: Display chemicals, description, dosage, and stock info.
- **FR-4: OCR Recognition**: Use camera to extract medicine names from prescriptions.
- **FR-5: AI Help**: Ask AI for medicine suggestions and usage guidance via OpenRouter.
- **FR-6: Inventory Tracking**: CTA to "Sell" medicine and update stock levels.
- **FR-7: Local Storage**: Save custom/modified medicines and sales logs via Hive.

## Non-Functional Requirements
- **NFR-1: File Size**: No single Dart file shall exceed 500 lines.
- **NFR-2: Performance**: Hero animations for medicine images must be smooth (60fps).
- **NFR-3: Reliability**: Focused error handling for API calls (Dio) and OCR failures.

## Acceptance Criteria
- **AC-1**: Given a prescription photo, when scanned, then the app must extract the medicine name.
- **AC-2**: Given a symptom list, when sent to AI, then the app must return medicine name, dosage, and warnings.
- **AC-3**: When a medicine is sold, the current stock must decrease, and a sale record must be created in Hive.
- **AC-4**: Medicine details must load standard data from external API and local data from Hive.

## Out of Scope
- Full E-commerce checkout or payment gateway integration.
- Multi-user authentication/RBAC (Admin only concept for stock).
- Real-time synchronization with cloud databases (Hive only).

## Error Handling Focus
- API timeout/failure in Dio interceptors.
- OCR low-confidence fallback (Manual entry dialog).
- Empty states for search and sales history.
