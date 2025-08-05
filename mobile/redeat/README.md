## Architecture & Data Flow

This project follows Clean Architecture principles to ensure separation of concerns and maintainability.

- **Core**: Shared components, error handling, and platform-specific utilities.
- **Features**: Feature modules such as `product` encapsulate domain, data, and presentation layers.
- **Domain Layer**: Contains entities and use cases representing business rules.
- **Data Layer**: Contains models and data sources handling data from remote APIs or local storage.
- **Presentation Layer** (if implemented): UI components and state management.

The `ProductModel` mirrors the `Product` entity and supports JSON serialization/deserialization to facilitate data exchange between layers.

Unit tests ensure the correctness of models and business logic.
