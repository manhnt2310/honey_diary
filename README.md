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


Key architectural decisions:

- **Layered structure**:  
  - **Models** hold plain Dart data classes.  
  - **Services** (e.g., `StorageService`) abstract away database or local-storage logic.  
  - **UI** in `screens/` and `widgets/` stays decoupled from data storage.  
- **State management**: Provider, BLoC.  
- **Routing**: Flutter’s built-in `Navigator`.  

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
