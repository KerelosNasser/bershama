# Bershama Project Setup Design

## Context
Initial foundation for Bershama pharmacy app. Need dependencies, MVC rules, constants, and theme.

## Functional Requirements
- **FR-1:** Update `pubspec.yaml` with `get`, `dio`, `hive`, `hive_flutter`, `google_mlkit_text_recognition`, `json_annotation`, `heroicons`, `flutter_animate`, `lottie`.
- **FR-2:** Create `lib/core/GEMINI.md` with MVC and file length rules.
- **FR-3:** Create `lib/core/constants.dart` with `baseUrl` and OpenRouter URL.
- **FR-4:** Create `lib/core/theme.dart` with Pharmacy Green (#2E7D32) and custom TextTheme.

## Non-Functional Requirements
- **NFR-1:** Files MUST NOT exceed 500 lines.
- **NFR-2:** Strict MVC separation.

## Acceptance Criteria
- **AC-1:** `pubspec.yaml` has all requested packages.
- **AC-2:** `lib/core/GEMINI.md` exists with specified content.
- **AC-3:** `lib/core/constants.dart` has `baseUrl` and `aiServiceUrl`.
- **AC-4:** `lib/core/theme.dart` defines `pharmacyTheme` with correct colors.

## Out of Scope
- Actual UI implementation (Views).
- Logic implementation (Controllers/Services).
- Backend integration.
