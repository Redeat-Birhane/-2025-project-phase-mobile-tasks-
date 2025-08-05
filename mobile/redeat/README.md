This task involves implementing and testing a local data source for caching products using SharedPreferences. It helps ensure the app works offline or loads temporary data while fetching from the server.

✅ Features Implemented
Created ProductLocalDataSourceImpl class to handle local storage of products.

Used SharedPreferences to cache product lists as JSON strings.

Implemented methods to:

Cache a list of products

Retrieve all cached products

Retrieve a single cached product by ID

Handled edge cases (e.g., no cache) using a custom CacheException.

🧪 Unit Testing
Created unit tests for:

cacheProducts() – ensures products are stored locally.

getCachedProducts() – retrieves cached products or throws exception.

getCachedProduct(String id) – retrieves a single product or throws exception.

Used mockito to mock SharedPreferences.