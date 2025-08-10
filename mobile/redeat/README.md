# Dependency Injection Setup

## Overview

This task involves setting up **Dependency Injection (DI)** in the Flutter ecommerce app using the **get_it** package. DI helps in decoupling the creation of objects from their usage, promoting better testability, maintainability, and adherence to Clean Architecture principles.

---

## What Was Done

- Added the `get_it` package to `pubspec.yaml`.
- Created an **Injection Container** (`injection_container.dart`) to register and provide all dependencies including:
    - Blocs
    - Use Cases
    - Repository Implementations
    - Data Sources (local & remote)
    - Core utilities like `NetworkInfo`
    - External libraries (HTTP client, SharedPreferences, Internet Connection Checker)
- Registered dependencies with appropriate scopes:
    - Factories for Blocs (new instance per request)
    - Lazy Singletons for Use Cases, Repositories, Data Sources, and Core utilities
- Ensured all dependency chains are resolved correctly, with constructor injection.
- Updated the `main.dart` to initialize the DI container before app startup.
- Integrated Bloc providers using the DI container to manage state efficiently.

---

## How to Test

- Run the app normally (`flutter run`).
- Verify that all screens requiring dependencies load without errors.
- No runtime errors related to missing dependencies should occur.
- Bloc instances should be created via the DI container.

---

## Benefits

- Clear separation of concerns.
- Easier to mock dependencies in tests.
- Centralized place for managing object creation and lifecycle.
- Facilitates scalability and maintainability.

---

## Notes

- Authentication feature injection will be added in a future task.
- UI consumption of Bloc will be covered in subsequent tasks.
