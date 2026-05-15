# Views Guidelines

- **Logic-Free**: Views must only contain UI code. Any business logic belongs in the controllers.
- **GetView**: Use `GetView<ControllerName>` for screens that primarily interact with a single controller.
- **Modular Widgets**: Extract small, reusable components to `lib/views/widgets/`.
- **Reactive UI**: Use `Obx` or `GetX` for reactive updates from controllers.
- **Theme Consistency**: Use `AppTheme` constants or `Theme.of(context)` to maintain a consistent look and feel.
