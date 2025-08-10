# Task 17: Implement Bloc for Product Feature

## Overview

This task involves implementing the BLoC (Business Logic Component) pattern to manage state and business logic for the Product feature in the eCommerce app. The BLoC handles loading, creating, updating, deleting, and retrieving products from the repository while maintaining clean separation of concerns and reactive UI updates.

---

## Task Breakdown

### 17.1 Event Classes

- **LoadAllProductsEvent**: Triggered to load all products.
- **GetSingleProductEvent**: Triggered to load a single product by ID.
- **CreateProductEvent**: Triggered to create a new product.
- **UpdateProductEvent**: Triggered to update an existing product.
- **DeleteProductEvent**: Triggered to delete a product by ID.

### 17.2 State Classes

- **InitialState**: Initial state before any action.
- **LoadingState**: Indicates ongoing data fetch or processing.
- **LoadedAllProductsState**: Represents successful loading of all products.
- **LoadedSingleProductState**: Represents successful loading of a single product.
- **ErrorState**: Represents an error during operations.

### 17.3 ProductBloc

- Manages all product-related events and emits corresponding states.
- Integrates with domain use cases: `getAllProductsUseCase`, `getProductUseCase`, `insertProductUseCase`, `updateProductUseCase`, `deleteProductUseCase`.
- Handles asynchronous operations and proper error handling.
- Emits loading, success, and error states to update the UI reactively.

---

## Testing

- Unit tests written using `bloc_test`, `mocktail`, and `flutter_test` packages.
- Tests cover success and failure scenarios for all major events.
- Ensures robustness of BLoC logic and state transitions.

---

## How to Run Tests

From your project root, run:

```bash
flutter test test/features/product/presentation/bloc/product_bloc_test.dart
