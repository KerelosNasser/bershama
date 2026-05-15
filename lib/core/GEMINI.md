# Bershama Core Guidelines

## MVC Architecture
Strict separation between UI (Views) and Logic (Controllers/Services).

- **Models**: Data structures and JSON serialization.
- **Views**: UI components (Widgets). Use GetX for binding.
- **Controllers**: Business logic and state management using GetX.
- **Services**: API calls, local storage (Hive), and external integrations.

## File Constraints
- **MAX 500 LINES**: Any file exceeding 500 lines MUST be split into smaller, focused files.
- **Single Responsibility**: Each file should have one clear purpose.

## State Management
- Use **GetX** for dependency injection and state management.
- Prefer `Obx` or `GetBuilder` for reactive UI updates.

## Technical Standards
- Follow standard Dart linting.
- Use `dio` for all network requests.
- Use `hive_ce` for local persistence.
