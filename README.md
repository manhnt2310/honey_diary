# honey_diary

A cross-platform personal diary app built with Flutter.  
Record your thoughts, moods, photos, and keep a private digital journal that runs on Android, iOS, Web, Windows, macOS, and Linux.

---

## Table of Contents

1. [Project Overview](#project-overview)  
2. [Features](#features)  
3. [Architecture & Project Structure](#architecture--project-structure)  
4. [Technology Stack](#technology-stack)  

---

## Project Overview

**honey_diary** is a beginner-friendly Flutter application scaffold designed for recording diary entries.  
This project demonstrates how to:

- Structure a Flutter codebase for multiple platforms  
- Manage dependencies via `pubspec.yaml`  

---

## Features

> _(Customize this list as you implement more features.)_

- Create, read, update, and delete (CRUD) diary entries  
- Attach photos to entries  
- Calendar view to browse by date  
- Secure local storage (SQLite, Share Preferences)   

---

## Architecture & Project Structure

### Layer Responsibilities

1. **Data Layer (`lib/data/`)**  
   - **`data_sources/`**: Contains low-level data providers (e.g., remote API clients, local SQLite/Hive helpers).  
   - **`models/`**: Plain Dart classes for JSON (de)serialization. These mirror the remote or local data structure.  
   - **`repositories/`**: Implements the `domain/repositories` interfaces by using one or more data sources. For example, `DiaryRepositoryImpl` could fetch entries from a local database or call a web API.

2. **Domain Layer (`lib/domain/`)**  
   - **`entities/`**: Core business objects (e.g., `DiaryEntry`, `Anniversary`, `WeatherForecast`) that have no external dependencies.  
   - **`repositories/`**: Abstract interfaces (e.g., `DiaryRepository`, `WeatherRepository`) that define what operations the app needs (fetch, save, delete).  
   - **`usecases/`**: Each use case encapsulates a single piece of application logic (e.g., `AddAnniversaryUseCase`, `GetDiaryEntriesUseCase`, `FetchWeatherUseCase`). Use cases depend only on repository interfaces, never on concrete implementations.

3. **Presentation Layer (`lib/presentation/`)**  
   - Organized by feature folder (e.g., `diary/`, `home/`, `weather/`, `anniversary_addition/`). Each feature typically contains:  
     - **Screens** (e.g., `DiaryScreen`, `HomeScreen`, `WeatherScreen`).  
     - **BLoCs / Cubits** (or other state‐management classes) responsible for exposing state to UI and handling user events.  
     - **Widgets** that compose each screen.  
   - This layer is decoupled from data-access details; it only interacts with the Domain via use cases.

4. **Initializer (`lib/initializer/`)**  
   - One place to configure dependency injection, register all BLoCs, repositories, use-cases, and data-sources with a service locator (e.g., GetIt).  
   - Ensures that `main.dart` remains minimal—just calls the initializer before running the app.

5. **Shared Utilities (`lib/shared/utils/`)**  
   - Common constants (e.g., API endpoints, date formats) found in `constants/`.  
   - Device utilities (screen size helpers, platform checks) in `device/`.  
   - Generic helper functions (e.g., validators, formatters) in `helpers/`.  
   - Any widget or helper that’s used across multiple features.

6. **Core Utilities (`lib/core/utils/injections.dart`)**  
   - Houses code for wiring up all dependencies (e.g., registering `DiaryRepositoryImpl` under the `DiaryRepository` interface).  
   - May also include environment configuration (e.g., different API URLs for dev vs. prod).
   
7. **Assets (`lib/assets/`)**  
   - Static files like fonts, animations, images, icons, and JSON templates that the app consumes at runtime.

---

### State Management & Routing

- **State Management**  
  - We’re primarily using **BLoC/Cubit** (via `flutter_bloc`) for feature-level state.  
  - Each feature’s BLoC/Cubit lives under `presentation/<feature>/` and emits states like `DiaryLoading`, `DiaryLoaded`, `DiaryError`.  
  - Presentation widgets subscribe to BLoC state streams and rebuild accordingly.

- **Routing**  
  - We leverage Flutter’s built-in `Navigator` with named routes registered in `main.dart`.  
  - Each feature declares its own route constants (e.g., `/home`, `/diary`, `/anniversary_add`).  
  - For more complex nested navigation, integration with a package like `go_router` could be added later, but is not yet implemented.


This Clean Architecture setup ensures that:

- **UI code** (presentation) knows only about domain use cases and does not depend on database or network details.  
- **Business logic** (domain) is entirely independent from Flutter and platform specifics.  
- **Data access** (data) can be swapped easily (e.g., switch from SQLite to REST API) by only changing data‐layer classes.  
- **Initialization** (initializer) is centralized, making it straightforward to add or modify dependencies without scattering `GetIt` calls throughout the app.  
- **Shared utilities** are kept in `shared/utils/` to avoid duplication across features.

---

## Technology Stack

- **Flutter SDK** — v3.x or above  
- **Dart** — language for Flutter apps  
- **Platform Embeddings**  
  - **Android**: Kotlin + Gradle  
  - **iOS/macOS**: Swift + Xcode  
  - **Windows/Linux**: CMake + C++  
- **Dependencies** (as declared in `pubspec.yaml`)  
  - State management: Provider/BLoC 
  - Local storage: sqflite/share preference
  - Image handling: `image_picker`  
  - Date/Time: `intl`  
  - (…and more—see `pubspec.yaml`)

---
