# Tech Gadol Product Catalog — Premium Edition

A high-end Flutter application for browsing tech gadgets, featuring a premium Black & Gold design system, offline support, and sophisticated animations.

## 1. Setup & Run Instructions

### Prerequisites
- **Flutter SDK**: `3.35.7` (Stable)
- **Dart SDK**: `3.9.2`

### Installation & Build
1. **Clone the repository**:
   ```bash
   git clone https://github.com/Melese999/product-catalog.git
   cd product-catalog
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Code** (JsonSerializable & Hive):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the Application**:
   ```bash
   flutter run
   ```

---

## 2. Architecture Overview

The project follows a **Feature-Driven Clean Architecture** to ensure modularity and scalability.

### Folder Structure
- `lib/core`:
  - `design_system`: Theme definitions, colors, and reusable atomic widgets.
  - `network`: Dio client configuration and API wrappers.
  - `router`: GoRouter configuration for deep-linking.
- `lib/features/products`:
  - `data`: Hive datasources, Models (extending Domain entities), and Repository implementations.
  - `domain`: Pure Dart entities and Repository interfaces.
  - `presentation`: BLoC for state management and UI pages (List, Detail, Showcase).

### State Management
- **BLoC (flutter_bloc)**: Used centralized `ProductBloc` to manage synchronizing the list and detail views, especially critical for tablet Master-Detail synchronization.
- **Cubit**: Lightweight `ThemeCubit` for dynamic theme switching.

### Key Decisions
- **Unified BLoC**: Merged List and Detail BLoCs to simplify state sharing between the Master and Detail panels on tablets.
- **Hive for Caching**: Chosen for its superior speed and minimal boilerplate compared to SQFlite.

---

## 3. Design System Rationale

### Theming
- **Black & Gold Palette**: Selected to convey a "Premium" and "Elite" brand identity. Uses high-contrast deep blacks and rich gold accents.
- **Typography**: Uses `GoogleFonts.outfit` for a modern, tech-focused aesthetic.

### Component Design
- **Atomic Widgets**: Components like `AppButton` and `CategoryChip` use a clear API with enums (e.g., `AppButtonType.primary`) and selective callbacks.
- **Scalable ProductCard**: Implemented a "Wide" mode specifically for the Master view on tablets to avoid text cramping and layout overflows.
- **Shimmer Skeletons**: Custom `ProductCardShimmer` ensures perceived performance remains high during data fetches.

---

## 4. Limitations & Future Improvements

### Limitations
- **Simple Caching**: Hive currently stores flat JSON maps; for complex relational queries, an ORM like Drift would be better suited.
- **Pagination Depth**: Currently supports basic skip-limit pagination; real-time cursor-based pagination would be more robust for large datasets.

### Shortcuts Taken
- **Local Error Logging**: Errors are currently printed to the console/UI; a production app should use a service like Sentry or Firebase Crashlytics.
- **Mock Data**: Unit tests use manual mocks; a more robust approach would involve generating mocks via `mockito` or `mocktail` for all edge cases.

---

## 5. AI Tools Usage



### How AI was Used:
- **Refactoring**: Automated the consolidation of the folder structure and import cleanup.
- **Feature Implementation**: Generated the initial logic for Hive caching and the staggered animation sequences.
- **Documentation**: Generated the detailed analysis documents and refined this README based on architectural patterns identified in the code.

### Refinements:
The AI's output was manually refined to fix dependency version conflicts (e.g., Hive vs JSON Serializable) and to ensure the Hero tags remained unique across Paginated lists.

---
*Senior Flutter Technical Assessment v1.3*
