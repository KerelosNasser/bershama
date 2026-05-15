# Bershama App Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build "Bershama", an educational pharmacy app using Flutter, GetX, AI, and OCR, following a strict MVC structure with modular documentation.

**Architecture:** Classic MVC with separate Service layer for infrastructure (OCR, AI, DB). Strict adherence to <500 lines per file and documented guidelines via subdirectory `.md` files.

**Tech Stack:** Flutter, GetX (State/Routing), Dio (API), Hive (Local DB), Google ML Kit (OCR), OpenRouter (AI).

---

### Task 1: Project Setup & Core Guidelines

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/core/GEMINI.md`
- Create: `lib/core/constants.dart`, `lib/core/theme.dart`

- [ ] **Step 1: Update dependencies**
Add `get`, `dio`, `hive`, `hive_flutter`, `google_mlkit_text_recognition`, `json_annotation`, `heroicons`, `flutter_animate`, `lottie`.
- [ ] **Step 2: Create Core Guidelines (GEMINI.md)**
Define the strict MVC rules, naming conventions, and 500-line limit for all subagents.
- [ ] **Step 3: Setup Theme & Constants**
Define pharmacy-themed colors (Green/White) and API base URLs.
- [ ] **Step 4: Commit**
`git add . && git commit -m "chore: initial setup and core guidelines"`

---

### Task 2: Data Models & Model Guidelines

**Files:**
- Create: `lib/models/GEMINI.md`
- Create: `lib/models/medicine_model.dart`
- Create: `lib/models/sale_record.dart`

- [ ] **Step 1: Write Medicine Model**
Include fields: `id`, `name`, `chemicals`, `description`, `dosage`, `current_stock`, `imageUrl`.
- [ ] **Step 2: Write Sale Record Model**
Include: `medicineId`, `quantity`, `timestamp`.
- [ ] **Step 3: Add Model Guidelines**
Instructions for JSON serialization and keeping models pure (no logic).
- [ ] **Step 4: Commit**
`git add . && git commit -m "feat: define data models"`

---

### Task 3: Infrastructure Services

**Files:**
- Create: `lib/services/GEMINI.md`
- Create: `lib/services/db_service.dart` (Hive)
- Create: `lib/services/ocr_service.dart` (ML Kit)
- Create: `lib/services/ai_service.dart` (OpenRouter/Dio)

- [ ] **Step 1: Implement Hive Service**
Initialize Hive and open boxes for `medicines` and `sales`.
- [ ] **Step 2: Implement OCR Service**
Wrapper for `google_mlkit_text_recognition` to extract text from images.
- [ ] **Step 3: Implement AI Service**
Dio client for OpenRouter to fetch medical advice.
- [ ] **Step 4: Add Service Guidelines**
Focus on singleton pattern and error handling.
- [ ] **Step 5: Commit**
`git add . && git commit -m "feat: implement infrastructure services"`

---

### Task 4: Controllers (The Brains)

**Files:**
- Create: `lib/controllers/GEMINI.md`
- Create: `lib/controllers/medicine_controller.dart`
- Create: `lib/controllers/inventory_controller.dart`

- [ ] **Step 1: Medicine Controller**
Handle A-Z sorting, search logic, and fetching from API/Hive.
- [ ] **Step 2: Inventory Controller**
Logic for "Sell" CTA: update stock in Hive + log sale.
- [ ] **Step 3: Add Controller Guidelines**
Instructions on GetX lifecycle (`onInit`, `onClose`) and `Obx` usage.
- [ ] **Step 4: Commit**
`git add . && git commit -m "feat: implement GetX controllers"`

---

### Task 5: Views - Main & Detail Screens

**Files:**
- Create: `lib/views/GEMINI.md`
- Create: `lib/views/home_view.dart`
- Create: `lib/views/medicine_detail_view.dart`
- Create: `lib/views/widgets/medicine_tile.dart`

- [ ] **Step 1: Home View**
A-Z scrollable list + search bar.
- [ ] **Step 2: Medicine Detail View**
Chemicals, dosage, and "Sell" CTA button. Use Hero animation for image.
- [ ] **Step 3: Add View Guidelines**
Focus on atomic widgets and keeping views logic-free.
- [ ] **Step 4: Commit**
`git add . && git commit -m "feat: implement main and detail views"`

---

### Task 6: Views - AI Help & OCR Integration

**Files:**
- Create: `lib/views/ai_help_view.dart`
- Create: `lib/views/ocr_scanner_view.dart`

- [ ] **Step 1: OCR Scanner View**
Camera preview with text detection overlay.
- [ ] **Step 2: AI Help View**
Chat interface for diagnosing symptoms via AI Service.
- [ ] **Step 3: Commit**
`git add . && git commit -m "feat: implement AI and OCR views"`

---

### Task 7: Routing & Final Integration

**Files:**
- Modify: `lib/main.dart`
- Create: `lib/routes/app_pages.dart`

- [ ] **Step 1: Setup Named Routes**
Define routes for Home, Detail, AI Help, and OCR.
- [ ] **Step 2: Initialize GetX App**
Setup Bindings and initial route in `main.dart`.
- [ ] **Step 3: Final Smoke Test**
Verify end-to-end flow: Scan -> Search -> View -> Sell -> AI Help.
- [ ] **Step 4: Commit**
`git add . && git commit -m "feat: final integration and routing"`
