# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run on a specific device
flutter run -d <device-id>        # e.g. -d ios, -d android, -d macos

# Build
flutter build ios
flutter build apk
flutter build macos

# Run tests
flutter test

# Run a single test file
flutter test test/domain/entities/journal_test.dart

# Lint / analyze
flutter analyze

# Generate code (freezed, build_runner)
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs

# Generate app icons
dart run flutter_launcher_icons

# Generate splash screen
dart run flutter_native_splash:create
```

## Architecture

Clean Architecture with three layers under `lib/`:

```
lib/
├── core/utils/injections.dart   # GetIt DI setup (service locator: sl)
├── data/                        # Data layer
│   ├── data_sources/            # SQLite (journal) + remote API (chat)
│   ├── models/                  # Serialization models
│   └── repositories/            # Concrete implementations
├── domain/                      # Domain layer (pure Dart, no Flutter deps)
│   ├── entities/                # Journal, ChatMessageEntity
│   ├── repositories/            # Abstract interfaces
│   └── usecases/                # One class per operation
├── presentation/                # Feature folders
│   └── <feature>/
│       ├── bloc/                # BLoC (event/state/bloc files)
│       ├── presentation/        # Page + View split
│       └── widgets/             # Reusable feature widgets
└── shared/utils/                # Constants, helpers, DeviceUtility
    └── helpers/database_helper.dart  # SQLite singleton
```

### Key patterns

**DI**: `get_it` service locator. The global `sl` instance is in `lib/core/utils/injections.dart`. `initInjections()` is called in `main()` before `runApp`. All BLoCs are registered as factories; everything else as lazy singletons.

**State management**: `flutter_bloc` for all features. Each feature has `bloc/`, `*_event.dart`, `*_state.dart`. Global BLoCs (`DiaryBloc`, `ChatBloc`) are provided via `MultiBlocProvider` in `main.dart`.

**Routing**: `GetMaterialApp` (from `get`) is the root widget, enabling Get navigation and GetX controllers app-wide.

**Local storage**: SQLite via `sqflite`. Schema is in `DatabaseHelper._createDB` — the `journals` table stores `imagePaths` as a comma-separated string. DB version is currently 3.

**AI Chat**: Uses `flutter_gemini` (primary) and `chat_gpt_sdk`. API keys are stored in `lib/presentation/chat/consts.dart`.

**First-run flow**: `main()` reads `SharedPreferences` to decide whether to show `OnboardingScreen` or `HomeScreen(startDate: ...)`. The `hasSeenIntro` and `selectedDate` keys control this.

**Assets**: Declared under `lib/assets/` (images, gifs, icons, json, fonts). Font family is `Lora`.
