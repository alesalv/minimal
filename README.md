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
- 💾 State persistence with hydration

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
          backgroundColor: *randomColor(),
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
  builder: (context, *) => Container(
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

## State Persistence

Minimal MVN provides built-in support for persisting and restoring state through hydration.

### 1. Make your state serializable

```dart
@immutable
class CounterState extends MMState {
  const CounterState({
    required this.count,
    required this.lastUpdated,
  });

  factory CounterState.fromJson(Map<String, dynamic> json) => CounterState(
    count: json['count'] as int,
    lastUpdated: DateTime.parse(json['lastUpdated'] as String),
  );

  final int count;
  final DateTime lastUpdated;

  Map<String, dynamic> toJson() => {
    'count': count,
    'lastUpdated': lastUpdated.toIso8601String(),
  };
}
```

### 2. Add hydration to your notifier

```dart
class CounterNotifier extends MMNotifier<CounterState> {
  CounterNotifier() : super(
    const CounterState(
      count: 0,
      lastUpdated: DateTime.now(),
    ),
  ) {
    // Load saved state when notifier is created
    hydrate(_hydrator);
  }

  final _hydrator = MMHydrator<CounterState>(
    key: 'counter_state',
    toJson: (state) => state.toJson(),
    fromJson: CounterState.fromJson,
  );

  Future<void> increment() async {
    notify(CounterState(
      count: state.count + 1,
      lastUpdated: DateTime.now(),
    ));
    // Save state after change
    await persist(_hydrator);
  }

  Future<void> reset() async {
    await clearPersistedState(_hydrator);
    notify(CounterState(
      count: 0,
      lastUpdated: DateTime.now(),
    ));
  }
}
```

### 3. Access persisted state in your UI

```dart
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = counterManager.notifier;
    
    return ListenableBuilder(
      listenable: notifier,
      builder: (context, _) => Column(
        children: [
          Text('Count: ${notifier.state.count}'),
          Text('Last Updated: ${notifier.state.lastUpdated}'),
          ElevatedButton(
            onPressed: notifier.increment,
            child: const Text('Increment'),
          ),
          TextButton(
            onPressed: notifier.reset,
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
```

### Advanced Hydration Features

#### State Versioning and Migration

```dart
final _hydrator = MMHydrator<CounterState>(
  key: 'counter_state',
  toJson: (state) => state.toJson(),
  fromJson: CounterState.fromJson,
  version: 2, // Current state version
  migrations: [
    MMHydrationMigration<CounterState>(
      fromVersion: 1,
      toVersion: 2,
      migrate: (json) => CounterState.fromJson({
        ...json,
        'lastUpdated': DateTime.now().toIso8601String(),
      }),
    ),
  ],
);
```

#### Schema Validation

```dart
final _hydrator = MMHydrator<CounterState>(
  key: 'counter_state',
  toJson: (state) => state.toJson(),
  fromJson: CounterState.fromJson,
  schemaValidator: (json) => 
    json.containsKey('count') && 
    json.containsKey('lastUpdated'),
);
```

#### Optimized Persistence

```dart
class CounterNotifier extends MMNotifier<CounterState> {
  // ... other code ...

  Future<void> bulkIncrement(int times) async {
    for (var i = 0; i < times; i++) {
      notify(CounterState(
        count: state.count + 1,
        lastUpdated: DateTime.now(),
      ));
    }
    // Use debounce to avoid excessive storage operations
    await persistWithDebounce(_hydrator);
  }
}
```

#### Event Handling

```dart
final _hydrator = MMHydrator<CounterState>(
  key: 'counter_state',
  toJson: (state) => state.toJson(),
  fromJson: CounterState.fromJson,
  onEvent: (event, error) {
    switch (event) {
      case HydrationEvent.started:
        debugPrint('Starting hydration');
        break;
      case HydrationEvent.completed:
        debugPrint('Hydration completed');
        break;
      case HydrationEvent.failed:
        debugPrint('Hydration failed: $error');
        break;
    }
  },
);
```