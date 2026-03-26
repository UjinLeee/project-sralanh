# AGENTS.md

## 1. Build / Lint / Test Commands

### Build Commands
- **Flutter Build**
  ```bash
  flutter build web
  flutter build ios
  flutter build android
  ```

### Lint Commands
- **Flutter Lint**
  ```bash
  flutter analyze
  ```

### Test Commands
- **Run All Tests**
  ```bash
  flutter test
  ```

- **Run a Single Test**
  To run a specific test file:
  ```bash
  flutter test test/path_to_test_file.dart
  ```

### Tips for Testing
- Use verbose mode for more detailed output:
  ```bash
  flutter test --verbose
  ```

## 2. Code Style Guidelines

### Imports
- Group and order imports as follows:
  1. Dart core libraries
  2. Flutter libraries
  3. Third-party libraries
  4. Local imports

Example:
```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:your_package/your_module.dart';
import 'your_file.dart';
```

### Formatting
- Use 2 spaces for indentation.
- Break lines at 80 characters for readability.

### Types
- Prefer explicit types over `var` where possible for clarity.
- Use `late` for non-nullable variables that are initialized later.

### Naming Conventions
- Use `camelCase` for variables and function names.
- Use `PascalCase` for class names and enum types.
- Avoid using underscores for naming. Instead, use full, descriptive names.

### Error Handling
- Use `try-catch` blocks for error handling.
- Provide user-friendly error messages.
- Log errors for debugging without exposing them to the end-user.

Example:
```dart
try {
  // risky operation
} catch (e) {
  print('Error occurred: $e');
}
```

## 3. Cursor Rules
- ### Design Principles
  - Follow UI guidelines from `@desing_system.md` and `@design_system_showcase_final.html`.
  - Use specific fonts: Korean (Gowun Dodum), Khmer (Kantumruy Pro).
  - Implement a strict 3-step layout for scriptures: translation - pronunciation - original text.

- ### Functional Constraints
  - Account/Profile features are not implemented; all data is stored locally (Zustand/Provider).
  - Scripture/prayer data is retrieved only from segmented JSON files as needed.

- ### Code Style
  - Based on Flutter (Dart) Material 3 with theme extension from `lib/theme/app_theme.dart`.

## 4. Best Practices
- Keep code modular and reusable.
- Use comments sparingly to explain complex logic, but ensure your code is self-explanatory.
- Regularly run tests before committing code to prevent integration issues.

---

**Note**: This document should be reviewed regularly to keep up with new updates or changes in coding standards.
