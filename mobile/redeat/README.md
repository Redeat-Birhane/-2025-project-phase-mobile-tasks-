# eCommerce Mobile App - Clean Architecture & TDD Implementation

This Flutter eCommerce app demonstrates a robust implementation following **Clean Architecture** principles and **Test-Driven Development (TDD)**. The app supports full CRUD (Create, Read, Update, Delete) operations for products, with smart data fetching depending on network availability.

---

## What is Implemented so far

### 1. Domain Layer

- **Product Entity:** Defined the core `Product` entity with fields `id`, `name`, `description`, `price`, and `imageUrl`.
- **Use Cases:** Implemented use cases for:
    - Creating a new product
    - Reading (getting) a product by ID
    - Updating an existing product
    - Deleting a product
- **Repository Contract:** Defined the abstract `ProductRepository` interface specifying the CRUD operations.

### 2. Data Layer

- **Models:** Created `ProductModel` to convert between domain entity and JSON (API data).
- **Remote Data Source:** Implemented `ProductRemoteDataSourceImpl` to communicate with a REST API for product data.
- **Local Data Source:** Implemented `ProductLocalDataSourceImpl` using `SharedPreferences` for caching products locally.
- **Repository Implementation:** Implemented `ProductRepositoryImpl` that:
    - Checks network connectivity via `NetworkInfo`
    - Fetches from remote data source when online and caches data locally
    - Fetches from local cache when offline
    - Properly handles server and cache exceptions

### 3. Core Layer

- **Error Handling:** Created custom exceptions (`ServerException`, `CacheException`) and failures (`ServerFailure`, `CacheFailure`, `NetworkFailure`).
- **Network Info:** Implemented `NetworkInfo` using `InternetConnectionChecker` package to detect network availability.

### 4. Testing

- **Unit Tests:** Written tests for:
    - Use cases
    - Repository implementation (mocking remote and local data sources)
    - NetworkInfo using Mockito for mocking connectivity
- **Mocking:** Used `mockito` with `build_runner` to generate mocks for dependencies.

---

## How It Works

- When a product-related operation is called, the repository checks the network status.
- If online, it interacts with the remote API and caches the results locally.
- If offline, it serves data from the local cache (if available).
- Error handling ensures that server or cache failures are gracefully managed and propagated.

---



