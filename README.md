# Tech Gadol Product Catalog

A premium Flutter application for browsing a product catalog, built with a custom design system and robust state management.

## 🚀 Features

- **Custom Design System**: Consistent and reusable UI components.
- **Responsive Layout**: Native Master-Detail support for tablets.
- **Robust API Integration**: Handles imperfect data with graceful defaults.
- **Search & Filtering**: Real-time debounced search and category chips.
- **State Management**: Built with Bloc/Cubit for scalability.
- **Deep Linking**: Seamless navigation with GoRouter.
- **Premium UX**: Hero animations and smooth transitions.

## 🛠 Tech Stack

- **UI**: Flutter, Google Fonts, Shimmer, CachedNetworkImage.
- **State Management**: flutter_bloc.
- **Navigation**: go_router.
- **Network**: dio.
- **Architecture**: Domain-Driven Design (DDD) principles.
- **Validation**: json_annotation, json_serializable.

## 🏗 Architecture

The project follows a feature-driven architecture split into:
- **Core**: Design system, theme management, and network utilities.
- **Catalog**: Product listing, searching, and pagination logic.
- **Product Details**: Comprehensive view for individual products.

## 🧪 Testing

The project includes unit tests for critical data and logic layers:
- `ProductModel`: Verifies JSON parsing and data validation.
- `ProductListBloc`: Verifies complex state transitions for search and pagination.

Run tests:
```bash
flutter test
```

## 📱 Getting Started

1. Clone the repository.
2. Run `flutter pub get`.
3. Run `dart run build_runner build` (optional, files are pre-generated).
4. Run `flutter run`.

---
*Senior Flutter Technical Assessment*
