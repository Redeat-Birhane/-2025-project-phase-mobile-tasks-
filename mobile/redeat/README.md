## Local Data Source

This project implements a local caching mechanism using `SharedPreferences` to store product data offline. When the device is offline, the app fetches products from the local cache to ensure a smooth user experience.

- Products are serialized and saved as JSON strings.
- Supports caching, updating, and deleting products locally.
- Improves app reliability during network interruptions.
