# 💊 Bershama (برشامة)
### An Educational Pharmacy Management & AI-Assistant App

**Bershama** is an educational Flutter project designed to teach students how to build professional-grade mobile applications. The name "Bershama" is a playful Arabic term for a pill/medicine. This project demonstrates the integration of modern mobile technologies including **AI (LLMs)**, **OCR (Computer Vision)**, and **Local Databases**, all wrapped in a clean, scalable architecture.

---

## 🎯 Educational Goals
This project is built to guide students through:
- **Clean MVC Architecture:** Strict separation of concerns to prevent "spaghetti code."
- **State Management:** Deep dive into the **GetX ecosystem** (Controllers, Bindings, Services).
- **Computer Vision:** Implementing **OCR** using Google ML Kit to read prescriptions.
- **AI Integration:** Leveraging **OpenRouter** to provide clinical guidance and diagnosis assistance.
- **Local Persistence:** Using **Hive** for high-performance NoSQL local storage.
- **Modern Networking:** Professional API integration using **Dio** with interceptors.
- **UI/UX Excellence:** Smooth animations (Hero, Lottie, Flutter Animate) and pharmacy-themed design.

---

## 🏗️ Project Structure
The project follows a strict **MVC (Model-View-Controller)** pattern with a dedicated **Service** layer for infrastructure. Every directory contains a `GEMINI.md` file with specific coding standards for that layer.

```text
lib/
├── core/           # 🧩 Global Constants, Themes, and App Config
├── models/         # 📦 Data Classes (JSON & Hive serialization)
├── controllers/    # 🧠 Business Logic & State (GetX)
├── views/          # 🎨 UI Screens & Reusable Widgets
├── services/       # ⚙️ Infrastructure (OCR, AI, DB, API)
└── routes/         # 🛣️ Named Routes and Dependency Bindings
```

---

## ✨ Key Features

### 1. Medicine Catalog (A-Z)
- Browse medicines categorized alphabetically.
- Fast search functionality filtering by name or chemical components.
- Smooth **Hero animations** transitioning from list to detailed view.

### 2. OCR Prescription Scanner
- Open the camera to scan physical doctor prescriptions.
- Automatically extracts medicine names using **Google ML Kit**.
- Quick-search integration: Scan a name and jump directly to its details.

### 3. AI Pharmacist Assistant
- "Help" screen where users input symptoms or patient details.
- Integrated with **OpenRouter (AI)** to provide:
  - Suggested medicines.
  - Detailed dosage instructions.
  - Critical warnings and contraindications.

### 4. Inventory & Sales Tracking
- Real-time stock management.
- **"Sell" CTA:** Quickly record sales, which automatically decreases stock and logs the transaction in the local history.
- Low-stock visual indicators.

### 5. Detailed Education
- Medicine detailed pages include:
  - Chemical composition.
  - Comprehensive descriptions for trainee learning.
  - Usage and dosage guidelines.

---

## 🛠️ Technical Stack
- **Framework:** Flutter (Latest)
- **State Management:** [GetX](https://pub.dev/packages/get)
- **Networking:** [Dio](https://pub.dev/packages/dio)
- **Database:** [Hive](https://pub.dev/packages/hive)
- **OCR:** [Google ML Kit Text Recognition](https://developers.google.com/ml-kit/vision/text-recognition)
- **AI:** [OpenRouter API](https://openrouter.ai/)
- **Animations:** [Flutter Animate](https://pub.dev/packages/flutter_animate) & [Hero Widgets](https://docs.flutter.dev/development/ui/animations/hero-animations)

---

## 📏 Coding Standards
To ensure the project remains a high-quality teaching tool, we enforce:
1. **Modular Files:** No Dart file exceeds **500 lines**.
2. **Logic Isolation:** Views contain **zero** business logic. All logic lives in Controllers.
3. **Reactive UI:** Using `Obx` for surgical rebuilds and performance.
4. **Clean Code:** Standardized naming conventions and comprehensive `.md` documentation within every layer.

---

## 🚀 Getting Started
1. **Clone the repo.**
2. **Setup API Keys:** Add your OpenRouter API key in `lib/core/constants.dart`.
3. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
4. **Run Code Generation:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
5. **Launch:**
   ```bash
   flutter run
   ```

---

*Designed for students, built for the future.* 💊🚀
