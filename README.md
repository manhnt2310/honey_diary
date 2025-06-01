
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

  

>  _(Customize this list as you implement more features.)_

  

- Create, read, update, and delete (CRUD) diary entries

- Attach photos to entries

- Calendar view to browse by date

- Secure local storage (SQLite, Share Preferences)

  

---

  

## Architecture & Project Structure

  

### Layer Responsibilities

  

The **honey_diary** project follows Clean Architecture, divided into three main layers plus supporting folders. Each layer corresponds to the following directories under `lib/`:

  

1.  **Data Layer (`lib/data/`)**

-  **`data_sources/`**: Contains classes responsible for actual data access. Currently, you have `journal_local_data_source.dart` to perform CRUD operations on the local database (SQLite/Hive).

-  **`models/`**: Contains `journal_model.dart`, which defines how to (de)serialize data between the local storage and the domain layer.

-  **`repositories/`**: Contains `journal_repository_impl.dart`, which implements the `JournalRepository` interface (from the domain layer) and calls `JournalLocalDataSource` to read/write data.

  

2.  **Domain Layer (`lib/domain/`)**

-  **`entities/`**: Contains `journal.dart`—a pure Dart class defining the Journal object and its required fields (id, title, content, date, etc.).

-  **`repositories/`**: Contains `journal_repository.dart`—an abstract interface defining methods: `getAllJournals()`, `addJournal()`, `updateJournal()`, and `deleteJournal()`.

-  **`usecases/`**: Contains four use case classes (`add_journal.dart`, `get_all_journals.dart`, `update_journal.dart`, `delete_journal.dart`). Each class encapsulates the corresponding business logic and only calls the repository interface.

  

3.  **Presentation Layer (`lib/presentation/`)**

- Organized into feature folders (for example: `diary/`, `journal_addition/`, `journal_detail/`, `home/`, `intro/`, `start/`, `weather/`).

- Within each feature (using `diary/` as an example):

-  **`bloc/`**: Contains `diary_bloc.dart`, `diary_event.dart`, and `diary_state.dart` to manage state.

-  **`diary_page.dart`**: Instantiates `DiaryBloc` via GetIt and provides the main UI (Scaffold + AppBar).

-  **`diary_view.dart`**: Contains actual widgets (ListView, JournalCard, Form, etc.).

-  **`widgets/`**: Contains reusable child widgets (e.g., `JournalCard`, `JournalForm`, etc.).

  



---

  

### State Management & Routing

  

-  **State Management**

- We’re primarily using **BLoC/Cubit** (via `flutter_bloc`) for feature-level state.

- Each feature’s BLoC/Cubit lives under `presentation/<feature>/` and emits states like `DiaryLoading`, `DiaryLoaded`, `DiaryError`.

- Presentation widgets subscribe to BLoC state streams and rebuild accordingly.

  

-  **Routing**

- We leverage Flutter’s built-in `Navigator` with named routes registered in `main.dart`.

- Each feature declares its own route constants (e.g., `/home`, `/diary`, `/journal_add`).
  
  

This Clean Architecture setup ensures that:

  

-  **UI code** (presentation) knows only about domain use cases and does not depend on database or network details.

-  **Business logic** (domain) is entirely independent from Flutter and platform specifics.

-  **Data access** (data) can be swapped easily (e.g., switch from SQLite to REST API) by only changing data‐layer classes.

-  **Initialization** (initializer) is centralized, making it straightforward to add or modify dependencies without scattering `GetIt` calls throughout the app.

-  **Shared utilities** are kept in `shared/utils/` to avoid duplication across features.

  

---

  

## Technology Stack

  

-  **Flutter SDK** — v3.x or above

-  **Dart** — language for Flutter apps

-  **Platform Embeddings**

-  **Android**: Kotlin + Gradle

-  **iOS/macOS**: Swift + Xcode

-  **Windows/Linux**: CMake + C++

-  **Dependencies** (as declared in `pubspec.yaml`)
 
- State management: Provider/BLoC

- Local storage: sqlite/share preference

- Image handling: `image_picker`

- Date/Time: `intl`

- (…and more—see `pubspec.yaml`)

  

---