# AURIFY

> A modern, minimalist luxury e-commerce mobile application built with Flutter, Provider, Dio, and Firebase.

---

## 📱 Project Overview

### **Application Name**
**AURIFY**

### **Brief Description**
AURIFY is an elegant, luxury-tier e-commerce mobile application designed with a sleek monochrome aesthetic. It delivers a fast, seamless shopping experience featuring product discovery, search with debounce, category filtering, detailed product showcases, persistent wishlists, shopping cart management, and robust Firebase authentication.

### **Main Features**
- **Animated Splash Screen & Session Routing**: Fluid entrance animations with auto-session detection that directs logged-in users directly to Home, or to Login if unauthenticated.
- **Firebase Authentication**: Full user authentication workflow (Email/Password Sign-In, Account Registration, Forgot Password Reset, and Sign Out).
- **Product Discovery & Category Filtering**: Browse products with dynamic category chips (`All`, `Beauty`, `Fragrances`, `Furniture`, `Groceries`, etc.) fetched live from DummyJSON.
- **Live Search with Debounce**: Real-time product search with a 400ms debounce powered by `https://dummyjson.com/products/search?q={query}` and the `ProductSearchDetailsModel`.
- **Comprehensive Product Details**: Rich product showcase with image carousel, interactive indicators, stock/rating badges, expandable descriptions, dynamic price calculations, and tags.
- **Persistent Favorites / Wishlist**: Mark and unmark products as favorites across Home, Details, and Wishlist screens. Favorites persist locally via `SharedPreferences` across app restarts.
- **Persistent Shopping Cart**: Add products with custom quantities, increment/decrement, remove items, live tax/shipping calculations, and simulated checkout with local persistence.
- **Graceful Application States**:
  - **Loading States**: Custom progress indicators and skeleton feedback.
  - **Error States with Retry**: Crash-resilient Dio and Firebase error handling with dedicated "Retry" action buttons and pull-to-refresh.
  - **Empty States**: Tailored empty views with interactive actions for "No Search Results", "No Favorite Products", "No Available Products in Category", and "Empty Cart".

---

## 🚀 Setup Instructions

### **Prerequisites**
- **Flutter SDK**: `>= 3.5.0` (Dart `>= 3.5.0 < 4.0.0`)
- **Android Studio / VS Code** with Flutter and Dart plugins
- **Android Device / Emulator** (Android 5.0 Lollipop, API level 21+) or **iOS Simulator**

### **Step-by-Step Installation**

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/aurify_task.git
   cd aurify_task
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**
   - The project uses **Firebase Core** and **Firebase Authentication**.
   - Ensure `google-services.json` is placed in `android/app/` for Android.
   - For iOS, ensure `GoogleService-Info.plist` is configured in `ios/Runner/`.
   - The configuration is initialized in `lib/main.dart` using `DefaultFirebaseOptions.currentPlatform` generated via FlutterFire CLI.

4. **Run the Application**
   ```bash
   # Run on connected device / emulator
   flutter run
   ```

5. **Run Tests & Static Analysis**
   ```bash
   # Execute unit & smoke tests
   flutter test

   # Run static code analysis
   flutter analyze
   ```

### **API Information**
The application interacts with the public [DummyJSON API](https://dummyjson.com/):
- **Products Catalog**: `GET https://dummyjson.com/products?limit=50`
- **Product Search**: `GET https://dummyjson.com/products/search?q={query}`
- **Categories**: `GET https://dummyjson.com/products/categories`
- **Product Details**: `GET https://dummyjson.com/products/{id}`

*No private API keys or sensitive credentials are required to run the public DummyJSON APIs.*

---

## 🛠️ Technical Decisions

### **1. State Management Approach**
- **Provider & ChangeNotifier**: Used for clean, predictable, and reactive state management.
- **Route-Scoped Dependency Injection**: Instead of registering a large global `MultiProvider` in `main.dart`, controllers (`HomeController`, `LoginController`, `ProductDetailsController`, `WishlistController`, `CartController`, `ProfileController`) are injected on-demand inside [AppRouter](file:///c:/Users/safah/AndroidStudioProjects/aurify_task/lib/core/routes/app_router.dart) using `ChangeNotifierProvider`. This ensures controllers are created when entering a screen and automatically disposed when popped.
- **Reactive Service Layer**: Singletons (`FavoritesService`, `CartService`) extend `ChangeNotifier`. Screen controllers register as listeners to synchronize heart icons, cart badges, and wishlist counts live across all screens simultaneously.

### **2. Project Structure (Feature-First)**
The codebase follows a modular **Feature-First Architecture** for scalability and maintainability:
```text
lib/
├── core/
│   ├── app_config/       # Theme, fonts, global configurations
│   ├── responsive/       # Screen scaling and responsive breakpoints
│   ├── routes/           # Named routes and AppRouter generator
│   ├── services/         # Core singleton services (Auth, Favorites, Cart)
│   └── theme/            # AppColors, AppTextStyles, AppTheme
├── features/
│   ├── splash_screen/    # Animated splash view & session routing
│   ├── login_screen/     # Auth sign-in view, controller & widgets
│   ├── registration_screen/ # Auth sign-up view, controller & widgets
│   ├── home_screen/      # Catalog, search, categories, controller & service
│   ├── product_details_screen/ # Product showcase, controller & service
│   ├── wishlist_screen/  # Favorites list, controller & widgets
│   ├── cart_screen/      # Cart management, controller, service & widgets
│   └── profile_screen/   # User profile, account info & Firebase logout
├── firebase_options.dart # Platform Firebase credentials
└── main.dart             # Application root entry point
```

### **3. API Integration Approach**
- **Dio Client**: Network requests are managed via `Dio` with configured base URLs, connection timeouts (15s), and receive timeouts (15s).
- **Service Isolation**: Each feature houses its own service (e.g. `HomeProductService`, `ProductDetailsService`) to keep network logic separated from UI controllers.
- **Model Serialization**: Strongly-typed JSON models with `fromJson` and `toJson` factory methods.

### **4. Local Storage Solution**
- **SharedPreferences**: Used for offline persistence of both **Favorites** and **Cart Items**.
- **JSON Serialization**: Full `Product` models and `CartItemModel` objects are serialized to JSON strings and stored in local preferences under dedicated keys (`'aurify_favorite_products'` and `'aurify_cart_items'`).
- **Startup Initialization**: Both `FavoritesService.instance.init()` and `CartService.instance.init()` are invoked asynchronously in `main.dart` before `runApp()`, ensuring instant data availability without flickering.

---

## 🤖 AI Usage

- **Tool**: ChatGPT
- **Usage & Contributions**:
  - **UI/UX Design Architecture**: Assistance in crafting a modern, minimalist luxury design system (monochrome palette, typography scale, elevated cards, and micro-interactions).
  - **Error Handling & State Resilience**: Suggested structured `DioException` error mapping and human-readable Firebase Auth exception translations to ensure the application handles failures gracefully without crashing.
