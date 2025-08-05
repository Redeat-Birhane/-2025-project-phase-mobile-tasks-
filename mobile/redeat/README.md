This task involved creating the remote data source layer for the Ecommerce app, responsible for fetching and manipulating product data from a RESTful API.

Features Implemented
ProductRemoteDataSourceImpl class that implements the contract ProductRemoteDataSource.

Utilized the API base URL from a constants file to ensure maintainability.

Implemented all CRUD operations using HTTP requests:

getAllProducts() — Fetches all products from the API.

getProduct(String id) — Retrieves a single product by ID.

createProduct(Product product) — Sends a new product to the API.

updateProduct(Product product) — Updates an existing product on the API.

deleteProduct(String id) — Deletes a product by ID.

JSON serialization and deserialization for network communication.

Error handling by throwing ServerException on unexpected status codes.

Notes
The implementation follows Clean Architecture principles and uses the repository pattern.

API constants are managed separately in the ApiConstants class.

This setup enables seamless integration between the domain layer and the remote API.