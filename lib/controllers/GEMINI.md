# Controllers Guidelines

- Use `onInit` for initial data fetching and state setup.
- Use `onClose` for cleaning up controllers, closing streams, or disposing controllers.
- Use `Rx` variables for reactive state.
- Use `Obx` in the UI to react to changes.
- Controllers must focus on business logic and state management.
- DO NOT put UI code or direct context-dependent code in controllers.
