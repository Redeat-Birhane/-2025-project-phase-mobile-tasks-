## 🏛 Architecture & Data Flow

This project follows the **Clean Architecture** principles, which divides the app into multiple layers:

- **Core:** Contains shared utilities, error handling, and common components.
- **Features:** Encapsulates feature-specific logic and modules. For example, the `product` feature contains entities, use cases, data models, repositories, and UI.
- **Data Layer:** Contains models (e.g., `ProductModel`) which map to and from JSON to communicate with external data sources or APIs.
- **Domain Layer:** Defines entities (`Product`), use cases (CRUD operations), and repository interfaces.
- **Presentation Layer:** Flutter UI screens that interact with the domain layer via use cases.

### Data Flow

- UI triggers use cases to perform operations.
- Use cases request data from repositories.
- Repositories use models to convert raw data (JSON) into entities.
- Entities are used throughout the app's business logic.
- Changes propagate back up to update the UI.

### Testing

- Unit tests ensure data model conversion correctness.
- Tests cover business logic and UI where applicable.

This structure promotes maintainability, scalability, and testability.
