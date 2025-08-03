## 🧱 Architecture Overview

This app follows the **Clean Architecture** pattern with separation into:

- **Core Layer**: Contains reusable utilities, exceptions, and constants.
- **Domain Layer**: Defines business logic through entities, use cases, and repository interfaces.
- **Data Layer**: Responsible for data models and interacting with APIs or local storage.
- **Presentation Layer**: (To be added) Handles UI and user interaction logic.

---

## 🔁 Data Flow

1. **Presentation** → calls a **Use Case**
2. **Use Case** → uses a **Repository Interface**
3. **Repository Implementation (Data Layer)** → fetches/stores using **ProductModel**
4. **ProductModel** converts raw data (e.g., JSON) to/from **Product Entity**

---

## 📄 Example: Product Flow

- `ProductModel` ←→ `JSON`
- `ProductModel` → `Product` (inherits from it)
- Repository uses `ProductModel` to send/receive data
- Use cases work with `Product` entities  
