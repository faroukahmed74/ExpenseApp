# Expense Tracker

A personal expense and budget tracker Flutter app for **Android** and **iOS**. Track spending by category, view lists and charts, and set monthly budget limits.

## Features

- **Log expenses** – Amount, category (Food, Transport, Bills, Shopping, Entertainment, Health, Other), optional note, and date.
- **Money flow** – List of transactions with filters by category and date range.
- **Statistics** – Total spent this month, spending by category (pie chart and list).
- **Budgets** – Set monthly limits per category and see how much is left on the home screen.

## Tech stack

| Aspect | Used in this app |
|--------|-------------------|
| **Flutter** | UI, navigation, forms, lists |
| **State** | Provider for expenses, filters, and totals |
| **Persistence** | Hive (local DB) so data survives app restart |
| **Charts** | fl_chart for “spending by category” pie chart |
| **Platforms** | Android and iOS |

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable)
- Android Studio / Xcode for running on device or simulator

### Run the app

```bash
# Install dependencies
flutter pub get

# Run on connected device or simulator (Android or iOS)
flutter run
```

### App icon (logo)

The app uses a custom launcher icon (green wallet/card with dollar). To regenerate it:

```bash
dart run scripts/generate_icon.dart
dart run flutter_launcher_icons
```

### Build for release and install on emulators

```bash
# Build release APK and iOS, then install on Android emulator
chmod +x scripts/build_and_install.sh
./scripts/build_and_install.sh
```

Or manually:

```bash
# Android release APK
flutter build apk --release
adb install -r build/app/outputs/flutter-apk/app-release.apk

# iOS release (for device; simulator uses debug)
flutter build ios --release
# Run on iOS simulator: flutter run -d <ios-simulator-id>
```

## Project structure

```
lib/
├── main.dart           # Entry point, Hive + Provider setup
├── app.dart            # MaterialApp, theme, routes
├── data/
│   └── expense_repository.dart   # Hive boxes for expenses & budgets
├── models/
│   ├── category.dart   # Expense categories (Food, Transport, etc.)
│   ├── expense.dart     # Expense model + Hive adapter
│   └── budget.dart      # Budget model + Hive adapter
├── providers/
│   └── expense_provider.dart     # State: list, filters, totals, CRUD
└── screens/
    ├── home_screen.dart          # Dashboard, “spent this month”, quick by category
    ├── add_edit_expense_screen.dart
    ├── expense_list_screen.dart  # Transactions + filters
    ├── stats_screen.dart        # Pie chart + by-category list
    └── budgets_screen.dart      # Set/edit monthly limits per category
```

## License

MIT.
