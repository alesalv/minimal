<p align="center">
  <img src="https://raw.githubusercontent.com/alesalv/minimal/main/example/assets/minimal.svg" width="100" alt="Minimal Logo">
</p>

# Minimal MVN

A minimal state management package for Flutter. Part of a minimalistic architecture based on the MVN (Model-View-Notifier) pattern.

This package aims for the simplest possible architecture, making it easier to understand and use, while offering an alternative to the growing complexity found in many other state management solutions, in an attempt to minimize side effects.

## Getting Started

Add Minimal to your pubspec.yaml:
```bash
dart pub add minimal_mvn
# or
flutter pub add minimal_mvn
```

and import the package:
```dart
import 'package:minimal_mvn/minimal_mvn.dart';
```

You can now start using Minimal's MVN pattern in your application. The quickest way is to follow the [4 steps below](#state-management-in-4-steps).

The package includes a complete [example app](/example) showing two use cases:
- The classical counter app that demonstrates basic state management. This shows off either the non disposable and the disposable notifiers.
- A morphing widget. This shows off two views using the same notifier, autodispose, and state selection to avoid unnecessary rebuilds.

## Features

- 🎯 MVN (Model-View-Notifier) pattern
- 🚀 Lazy initialization of notifiers
- 🔄 Optional autodispose for notifiers
- ⚡ State selection for optimized rebuilds
- 📦 Dependency injection with locator

## State Management in 4 Steps

### 1. Create an immutable UI state

```dart
@MappableClass()
class MorphingWidgetUIState extends MMState with MorphingWidgetUIStateMappable {
  const MorphingWidgetUIState({
    this.backgroundColor = Colors.blue,
    this.count = 0,
  });
  final Color backgroundColor;
  final int count;
}
```

### 2. Create a notifier to hold your UI state

```dart
class MorphingWidgetNotifier extends MMNotifier<MorphingWidgetUIState> {
  MorphingWidgetNotifier() : super(const MorphingWidgetUIState());

  void morph() => notify(
        state.copyWith(
          backgroundColor: _randomColor(),
          count: state.count + 1,
        ),
      );
}
```

### 3. Rebuild the UI when state changes

```dart
final notifier = morphingWidgetManager.notifier;
return ListenableBuilder(
  listenable: notifier,
  builder: (context, _) => Container(
    color: notifier.state.backgroundColor,
    child: const Text('Count: ${notifier.state.count}'),
  ),
);
```

#### 3.2 (Optimized) Rebuild the UI only when part of the state changes

```dart
final notifier = morphingWidgetManager.notifier;
return ListenableBuilder(
  listenable: notifier.select((state) => state.backgroundColor),
  builder: (context, _) => Container(
    color: notifier.state.backgroundColor,
  ),
);
```

### 4. Access the notifier upon user's actions

```dart
FloatingActionButton(
  onPressed: () => morphingWidgetManager.notifier.morph(),
);
```
