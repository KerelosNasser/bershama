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
