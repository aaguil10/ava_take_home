# Ava Flutter Take-Home Project

This is the implementation of the provided Figma design using Flutter.
https://www.figma.com/design/fgAwUqgFK30hJqYo0byDeG/Untitled?node-id=0-1&p=f

The project demonstrates clean architecture, state management, and responsiveness while following
Flutter best practices.

**Live Demo:** https://ava-take-home.web.app/

---

## 📱 Features

- Implements all screens and widgets as specified in the Figma design.
- Pixel-perfect UI with responsive layouts.
- Handles user interactions (buttons, inputs, gestures) as per requirements.
- Clean and maintainable architecture.

---

## 🛠️ Tech Stack

- **Flutter** (latest stable version)
- **State Management:** Cubit (from `flutter_bloc`)
  > **Note:** I chose Cubit for its simplicity and clarity. It enables predictable state management
  with minimal boilerplate while keeping the code highly testable and maintainable.

---

## Implementation Details

- **State Management:** Used Cubit (`flutter_bloc`) for predictable state handling.
- **Persistence:** User’s employment data is saved locally using `shared_preferences`, ensuring it
  persists across app restarts.
- **Animations:** Most animations use `AnimatedBuilder` and `TweenAnimationBuilder` for smooth
  transitions.
- **Navigation:** Used `go_router` for clean screen transitions.
- **Testing:** Added widget tests for form and UI validation and Cubit tests for state changes.

---

## Getting Started

### Prerequisites

- Flutter SDK installed (>= 3.x.x)
- Dart SDK included with Flutter
- IDE: Android Studio / VSCode

### Installation

Clone this repository:

```bash
git clone  https://github.com/aaguil10/ava_take_home.git
cd ava_take_home