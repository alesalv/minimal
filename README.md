<p align="center">
  <img src="https://raw.githubusercontent.com/alesalv/minimal/main/example/assets/minimal.svg" width="100" alt="Minimal Logo">
</p>

[![Pub Version](https://img.shields.io/pub/v/minimal_mvn?label=minimal_mvn&labelColor=333940&logo=dart)](https://pub.dev/packages/minimal_mvn) [![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

# Minimal MVN

A minimal state management package for Dart and Flutter. Part of a minimalistic architecture based on the MVN (Model-View-Notifier) pattern.

This package aims for the simplest possible architecture, making it easier to understand and use, while offering an alternative to the growing complexity found in many other state management solutions, in an attempt to minimize side effects.

## Try it

Check out the live example at [https://alesalv.github.io/minimal/](https://alesalv.github.io/minimal/)

**Counter**

The classical Flutter counter app demonstrates basic state management. The counter on the top is a non disposable notifier, so it keeps memory when re-entering the page. The one on the bottom is a disposable notifier, so it resets when re-entering the page.

**Chroma Counter**

A more advanced counter widget, which increases the counter, and randomly changes color and shape. The reveal button shows a second widget using the same notifier. Thanks to the autodispose feature, the notifier is disposed only when both the widgets are not visible anymore. The string on top of the choma counter updates every 10 counts, thanks to the select feature, which is used to avoid unnecessary rebuilds.

The complete source code is in the [example folder](/example).

## Getting Started

> **Requirements:** Dart `>=3.10.0` (for pure Dart apps) or Flutter `>=3.50.0` (for Flutter apps). For older Flutter versions, use `minimal_mvn: ^3.0.0`.

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
class ChromaCounterUIState with ChromaCounterUIStateMappable {
  const ChromaCounterUIState({
    this.backgroundColor = Colors.blue,
    this.count = 0,
  });
  final Color backgroundColor;
  final int count;
}
```

### 2. Create a notifier to hold your state

```dart
class ChromaCounterNotifier extends MMNotifier<ChromaCounterUIState> {
  ChromaCounterNotifier() : super(const ChromaCounterUIState());

  void nextMetamorph() => notify(
        state.copyWith(
          backgroundColor: _randomColor(),
          count: state.count + 1,
        ),
      );
}
```

### 3. Create a manager to access your notifier

```
final MMManager<ChromaCounterNotifier> chromaCounterManager =
    MMManager(ChromaCounterNotifier.new, autodispose: true);
```

### 4 Use the notifier from UI

###### Access the notifier upon user's actions

```dart
FloatingActionButton(
  onPressed: () => chromaCounterManager.notifier.nextMetamorph(),
);
```

###### Rebuild the UI when state changes

```dart
final notifier = chromaCounterManager.notifier;
return ListenableBuilder(
  listenable: notifier,
  builder: (context, _) => Container(
    color: notifier.state.backgroundColor,
    child: const Text('Count: ${notifier.state.count}'),
  ),
);
```

###### (Optimized) Rebuild the UI only when part of the state changes

```dart
final notifier = chromaCounterManager.notifier;
return ListenableBuilder(
  listenable: notifier.select((state) => state.backgroundColor),
  builder: (context, _) => Container(
    color: notifier.state.backgroundColor,
  ),
);
```

### Pure Dart Usage

Minimal works in pure Dart apps (CLI, servers, shared domain packages) with no Flutter dependency:

```dart
import 'package:minimal_mvn/minimal_mvn.dart';

class CounterNotifier extends MMNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => notify(state + 1);
}

final counterManager = MMManager(CounterNotifier.new, autodispose: true);

void main() {
  final counter = counterManager.notifier;
  final isEven = counter.select((count) => count.isEven);

  void onChange() => print('count=${counter.state}, isEven=${isEven.value}');

  isEven.addListener(onChange);
  counter.increment(); // prints: count=1, isEven=false
  counter.increment(); // prints: count=2, isEven=true
  isEven.removeListener(onChange); // autodisposes when last listener is removed
}
```

## Testing

### Widget Testing

In tests, you can override the notifier with a mock notifier through the minimal manager:

```dart
testWidgets('should update UI when state changes', (tester) async {
  // Use the minimal manager to override the notifier
  chromaCounterManager.override(MockCounterNotifier.new);

  await tester.pumpWidget(const MaterialApp(home: ChromaCounter()));

  // Change state through the mock notifier
  chromaCounterManager.notifier.nextMetamorph();
  await tester.pump();

  final newColor = _getContainerColor(tester);
  // Test the exact color instead of a random one
  expect(newColor, equals(Colors.red));
});
```

See the [example app tests](/example/test) for more testing examples.
