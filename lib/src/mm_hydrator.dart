import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mm_notifier.dart';
import 'mm_state.dart';

/// A type definition for functions that convert state to a JSON map
typedef ToJson<T extends MMState> = Map<String, dynamic> Function(T state);

/// A type definition for functions that create state from a JSON map
typedef FromJson<T extends MMState> = T Function(Map<String, dynamic> json);

/// A callback for hydration events
typedef HydrationCallback = void Function(HydrationEvent event, String? error);

/// Events that can occur during hydration
enum HydrationEvent {
  started,
  completed,
  failed,
}

/// Interface for storage providers
abstract class StorageProvider {
  /// Checks if the storage provider is initialized
  Future<bool> isInitialized();

  /// Initializes the storage provider
  Future<void> initialize();

  /// Gets a string value by key
  Future<String?> getString(final String key);

  /// Sets a string value by key
  Future<bool> setString(final String key, final String value);

  /// Removes a value by key
  Future<bool> remove(final String key);

  /// Clears all stored values
  Future<bool> clear();
}

/// Implementation of `StorageProvider` using `SharedPreferences`.
///
/// This class provides a concrete implementation of the `StorageProvider` interface
/// that uses the `SharedPreferences` package for data persistence. It enables the storage,
/// retrieval, and management of key-value pairs in a lightweight and persistent manner.
///
/// ### Features:
/// - Singleton pattern to ensure a single instance of the storage is used throughout the app.
/// - Initialization safety: Ensures that all operations are performed only after
///   successful initialization of the underlying `SharedPreferences`.
/// - Supports storing, retrieving, removing individual keys, and clearing all data.
///
/// ### Usage:
/// To get the singleton instance:
/// ```dart
/// final storage = await SharedPrefsStorage.getInstance();
/// ```
///
/// Example to set and get a key-value pair:
/// ```dart
/// await storage.setString('key', 'value');
/// final value = await storage.getString('key'); // Returns 'value'
/// ```
///
/// Example to clear all stored data:
/// ```dart
/// await storage.clear();
/// ```
///
/// The class also provides an asynchronous `initialize` method to ensure safe initialization.
/// Exceptions during initialization are propagated via a `Completer`.
class SharedPrefsStorage implements StorageProvider {
  SharedPrefsStorage._();

  static SharedPrefsStorage? _instance;
  static final Completer<void> _initializationCompleter = Completer<void>();

  /// Returns the singleton instance of `SharedPrefsStorage`.
  ///
  /// This method ensures that the instance is initialized only once.
  /// It also ensures that `_initialize` is called before returning the instance.
  ///
  /// Returns:
  /// - The singleton instance of `SharedPrefsStorage`.
  ///
  /// Throws:
  /// - Any exception encountered during `_initialize`.
  static Future<SharedPrefsStorage> getInstance() async {
    if (_instance == null) {
      _instance = SharedPrefsStorage._();
      await _instance!._initialize();
    }
    return _instance!;
  }

  SharedPreferences? _prefs;

  /// Internal initialization method for `SharedPreferences`.
  ///
  /// This method sets up the `_prefs` instance variable using `SharedPreferences.getInstance()`.
  /// It marks the initialization as complete through `_initializationCompleter`.
  ///
  /// If initialization fails, the error is propagated via `_initializationCompleter.completeError`.
  Future<void> _initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _initializationCompleter.complete();
    } catch (e) {
      _initializationCompleter.completeError(e);
    }
  }

  /// Checks whether the storage has been successfully initialized.
  ///
  /// Returns:
  /// - `true` if the underlying `SharedPreferences` instance (`_prefs`) is not null.
  /// - `false` otherwise.
  @override
  Future<bool> isInitialized() async => _prefs != null;

  /// Waits for the initialization of `SharedPreferences` to complete.
  ///
  /// This method returns a future that completes when the `_initializationCompleter`
  /// is resolved - either successfully or with an error.
  ///
  /// Example:
  /// ```dart
  /// await storage.initialize();
  /// ```
  ///
  /// Returns:
  /// - A `Future` that completes when the initialization is finished.
  ///
  /// Throws:
  /// - Any exception encountered during the initialization process.
  @override
  Future<void> initialize() => _initializationCompleter.future;

  /// Lazily retrieves the `SharedPreferences` instance.
  ///
  /// If the `_prefs` instance is not yet initialized, it triggers the `initialize` method.
  ///
  /// Returns:
  /// - The initialized instance of `SharedPreferences`.
  ///
  /// Throws:
  /// - Any exception encountered during initialization.
  Future<SharedPreferences> get prefs async {
    if (_prefs == null) {
      await initialize();
    }
    return _prefs!;
  }

  /// Retrieves a string value associated with the given key.
  ///
  /// Parameters:
  /// - [key]: The key to look up in the local storage.
  ///
  /// Returns:
  /// - The string value corresponding to the key, or `null` if not found.
  @override
  Future<String?> getString(final String key) async {
    final p = await prefs;
    return p.getString(key);
  }

  /// Stores a string value associated with the given key.
  ///
  /// Parameters:
  /// - [key]: The key under which the value will be stored.
  /// - [value]: The string value to store.
  ///
  /// Returns:
  /// - `true` if the value was successfully stored.
  /// - `false` otherwise.
  @override
  Future<bool> setString(final String key, final String value) async {
    final p = await prefs;
    return p.setString(key, value);
  }

  /// Removes a value associated with the given key.
  ///
  /// Parameters:
  /// - [key]: The key of the value to be removed.
  ///
  /// Returns:
  /// - `true` if the key-value pair was successfully removed.
  /// - `false` otherwise.
  @override
  Future<bool> remove(final String key) async {
    final p = await prefs;
    return p.remove(key);
  }

  /// Clears all values stored in `SharedPreferences`.
  ///
  /// Returns:
  /// - `true` if all data was successfully cleared.
  /// - `false` otherwise.
  @override
  Future<bool> clear() async {
    final p = await prefs;
    return p.clear();
  }
}

/// Represents a state migration
class MMHydrationMigration<T extends MMState> {
  const MMHydrationMigration({
    required this.fromVersion,
    required this.toVersion,
    required this.migrate,
  });

  final int fromVersion;
  final int toVersion;
  final T Function(Map<String, dynamic>) migrate;
}

/// Minimal hydrator for persisting and restoring state.
///
/// The `MMHydrator` class provides a framework for persisting and restoring application
/// state, ensuring that state data remains retained across app restarts.
/// It is designed to be flexible, extendable, and integrates versioning and migrations
/// to handle changes in state structure over time.
///
/// ### Features:
/// - **State Persistence**: Saves state in a storage provider like `SharedPreferences`.
/// - **State Restoration**: Loads previously saved states and restores them in the application.
/// - **Versioning**: Tracks and integrates version changes with stored data.
/// - **Migrations**: Supports transitioning old state data to newer state structures seamlessly.
/// - **Schema Validation**: Ensures that state conforms to a defined schema before usage.
/// - **Debounce Support**: Optimizes frequent state-saving operations through delay mechanisms.
/// - **Customizable Storage**: Allows users to specify their own `StorageProvider` implementation.
/// - **Event Notifications**: Provides hooks to track the hydration process (loading, saving, clearing).
///
/// ### Example Usage:
/// ```dart
/// final hydrator = MMHydrator<MyState>(
///   key: 'myStateKey',
///   toJson: (state) => state.toJson(),
///   fromJson: (json) => MyState.fromJson(json),
///   version: 1,
///   migrations: [
///     MMHydrationMigration(
///       fromVersion: 1,
///       toVersion: 2,
///       migrate: (json) => MyState.fromJson(_migrateJsonVersion1To2(json)),
///     ),
///   ],
///   onEvent: (event, error) {
///     if (event == HydrationEvent.failed) {
///       debugPrint('Hydration failed: $error');
///     }
///   },
/// );
///
/// // Save the state
/// await hydrator.save(myState);
///
/// // Load the state
/// final loadedState = await hydrator.load();
///
/// // Clear the state
/// await hydrator.clear();
/// ```
///
/// ### Parameters:
/// - [key]: A unique storage key for state persistence.
/// - [toJson]: A function converting the state object to a JSON map.
/// - [fromJson]: A function constructing the state object from a JSON map.
/// - [storage]: An optional custom implementation of `StorageProvider`. Defaults to `SharedPrefsStorage`.
/// - [version]: Current version of the state. Defaults to `1`.
/// - [migrations]: A list of version migrations for state transitions.
/// - [onEvent]: Callback to handle hydration events.
/// - [schemaValidator]: Optional function to validate the schema of the hydrated JSON data.
///
/// ### Methods:
/// - [load]: Loads the state from storage.
/// - [save]: Persists the current state to storage.
/// - [saveWithDebounce]: Delays state-saving to optimize frequent updates.
/// - [saveAll]: Saves multiple states simultaneously.
/// - [clear]: Clears the stored state data.
/// - [dispose]: Cleans up internal resources such as timers.
///
/// This class is the backbone of state hydration workflows, enabling developers
/// to ensure both reliability and flexibility with persisted app states.
class MMHydrator<T extends MMState> {
  MMHydrator({
    required this.key,
    required this.toJson,
    required this.fromJson,
    final StorageProvider? storage,
    this.version = 1,
    this.migrations = const [],
    this.onEvent,
    this.schemaValidator,
  }) {
    unawaited(_initializeStorage(storage));
  }

  final String key;
  final ToJson<T> toJson;
  final FromJson<T> fromJson;
  final int version;
  final List<MMHydrationMigration<T>> migrations;
  final HydrationCallback? onEvent;
  final bool Function(Map<String, dynamic>)? schemaValidator;

  StorageProvider? _storage;
  final Completer<void> _initializationCompleter = Completer<void>();
  Timer? _debounceTimer;

  bool get isInitialized => _storage != null;

  Future<void> _initializeStorage(final StorageProvider? storage) async {
    try {
      _storage = storage ?? await SharedPrefsStorage.getInstance();
      await _storage?.initialize();
      _initializationCompleter.complete();
    } catch (e) {
      _initializationCompleter.completeError(e);
    }
  }

  Future<void> ensureInitialized() => _initializationCompleter.future;

  bool _validateJson(final Map<String, dynamic> json) {
    try {
      return schemaValidator?.call(json) ?? true;
    } on Exception catch (e) {
      debugPrint('Schema validation error: $e');
      return false;
    }
  }

  Map<String, dynamic>? _migrateIfNeeded(
    final Map<String, dynamic> json,
    final int storedVersion,
  ) {
    if (storedVersion == version) {
      return json;
    }

    try {
      var currentJson = json;
      var currentVersion = storedVersion;

      while (currentVersion < version) {
        final migration = migrations.firstWhere(
          (final m) =>
              m.fromVersion == currentVersion && m.toVersion > currentVersion,
        );

        final migratedState = migration.migrate(currentJson);
        currentJson = toJson(migratedState);
        currentVersion = migration.toVersion;
      }

      return currentJson;
    } on Exception catch (e) {
      debugPrint('Migration error: $e');
      return null;
    }
  }

  Future<T?> load() async {
    onEvent?.call(HydrationEvent.started, null);

    try {
      await ensureInitialized();

      final json = await _storage?.getString(key);
      if (json == null) {
        onEvent?.call(HydrationEvent.completed, null);
        return null;
      }

      final dynamic decoded = jsonDecode(json);
      if (decoded is! Map<String, dynamic>) {
        onEvent?.call(HydrationEvent.failed, 'Invalid JSON structure');
        return null;
      }

      if (!_validateJson(decoded)) {
        onEvent?.call(HydrationEvent.failed, 'Schema validation failed');
        return null;
      }

      final storedVersion = decoded['version'] as int? ?? 1;
      final data = decoded['data'] as Map<String, dynamic>? ?? decoded;

      final migratedData = _migrateIfNeeded(data, storedVersion);
      if (migratedData == null) {
        onEvent?.call(HydrationEvent.failed, 'Migration failed');
        return null;
      }

      final state = fromJson(migratedData);
      onEvent?.call(HydrationEvent.completed, null);
      return state;
    } on FormatException {
      onEvent?.call(HydrationEvent.failed, 'Invalid JSON format');
      return null;
    } on Exception catch (e) {
      onEvent?.call(HydrationEvent.failed, e.toString());
      return null;
    }
  }

  Future<bool> save(final T state) async {
    onEvent?.call(HydrationEvent.started, null);

    try {
      await ensureInitialized();

      final stateJson = toJson(state);
      final json = jsonEncode({
        'version': version,
        'data': stateJson,
      });

      final result = await _storage?.setString(key, json);

      if (result ?? false) {
        onEvent?.call(HydrationEvent.completed, null);
      } else {
        onEvent?.call(HydrationEvent.failed, 'Save operation failed');
      }

      return result ?? false;
    } on Exception catch (e) {
      onEvent?.call(HydrationEvent.failed, e.toString());
      return false;
    }
  }

  Future<bool> saveWithDebounce(
    final T state, {
    final Duration duration = const Duration(milliseconds: 500),
  }) async {
    _debounceTimer?.cancel();

    final completer = Completer<bool>();

    _debounceTimer = Timer(duration, () async {
      try {
        final result = await save(state);
        completer.complete(result);
      } catch (e) {
        completer.completeError(e);
      }
    });

    return completer.future;
  }

  Future<bool> saveAll(final List<T> states) async {
    try {
      final results = await Future.wait(
        states.map(save),
      );
      return !results.contains(false);
    } on Exception catch (e) {
      debugPrint('Error in batch save: $e');
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      await ensureInitialized();
      final result = await _storage?.remove(key);
      return result ?? false;
    } on Exception catch (e) {
      debugPrint('Error clearing state: $e');
      return false;
    }
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}

/// Extension methods for hydration support in [MMNotifier].
///
/// This extension provides methods to integrate state persistence and restoration
/// functionalities into [MMNotifier].
///
/// The methods make use of [MMHydrator] to load, save, and clear the persisted state.
/// These simplify handling state management that requires persistence.
///
/// The methods are:
/// - [hydrate]: Restores the state from the persisted storage using the given [MMHydrator].
/// - [persist]: Saves the current state of the notifier to the storage.
/// - [persistWithDebounce]: Saves the state with a debounce for better performance under rapid state changes.
/// - [clearPersistedState]: Clears the state data persisted in storage.
extension MMNotifierHydration<T extends MMState> on MMNotifier<T> {
  /// Restores the state of the notifier from persisted storage via the given [MMHydrator].
  ///
  /// This method attempts to load a previously saved state using the hydrator's [load] method.
  /// If the state is successfully loaded, it will be applied to the notifier using [notify].
  ///
  /// Returns:
  /// - `true` if the state was successfully hydrated.
  /// - `false` if the loading process failed or no state was found.
  ///
  /// Example usage:
  /// ```dart
  /// final success = await notifier.hydrate(hydrator);
  /// if (success) {
  ///   print('State successfully hydrated!');
  /// }
  /// ```
  Future<bool> hydrate(final MMHydrator<T> hydrator) async {
    try {
      final loadedState = await hydrator.load();
      if (loadedState != null) {
        notify(loadedState);
        return true;
      }
      return false;
    } on Exception catch (e) {
      debugPrint('Error hydrating state: $e');
      return false;
    }
  }

  /// Saves the current state of the notifier to the storage using the provided [MMHydrator].
  ///
  /// This method immediately persists the current [state] of the notifier to the storage.
  ///
  /// Returns:
  /// - `true` if the state was successfully saved.
  /// - `false` if the save operation failed.
  ///
  /// Example usage:
  /// ```dart
  /// final success = await notifier.persist(hydrator);
  /// if (success) {
  ///   print('State successfully persisted!');
  /// }
  /// ```
  Future<bool> persist(final MMHydrator<T> hydrator) async {
    return hydrator.save(state);
  }

  /// Saves the current state of the notifier to storage with a debounce period.
  ///
  /// This method delays the save operation by a given [duration] (defaults to 500ms) to
  /// prevent rapid consecutive saves, which can improve performance and reduce storage writes.
  ///
  /// Parameters:
  /// - [hydrator]: The [MMHydrator] to handle the storage.
  /// - [duration]: The debounce period before the state is saved.
  ///
  /// Returns:
  /// - `true` if the state was successfully saved after the debounce period.
  /// - `false` if the save operation failed.
  ///
  /// Example usage:
  /// ```dart
  /// final success = await notifier.persistWithDebounce(hydrator, duration: Duration(seconds: 1));
  /// if (success) {
  ///   print('State successfully persisted after debounce!');
  /// }
  /// ```
  Future<bool> persistWithDebounce(
    final MMHydrator<T> hydrator, {
    final Duration duration = const Duration(milliseconds: 500),
  }) async {
    return hydrator.saveWithDebounce(state, duration: duration);
  }

  /// Clears the persisted state data from storage using the given [MMHydrator].
  ///
  /// This method removes any stored data related to the current state.
  ///
  /// Returns:
  /// - `true` if the persisted state was successfully cleared.
  /// - `false` if the operation failed.
  ///
  /// Example usage:
  /// ```dart
  /// final success = await notifier.clearPersistedState(hydrator);
  /// if (success) {
  ///   print('Persisted state successfully cleared!');
  /// }
  /// ```
  Future<bool> clearPersistedState(final MMHydrator<T> hydrator) async {
    return hydrator.clear();
  }
}
