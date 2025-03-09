import 'package:flutter/material.dart';

import 'mm_notifier.dart';

/// Minimal manager
///
/// A minimal manager is responsible for handling the lifecycle of a
/// [MMNotifier]. It lazily creates the notifier's instance, provides
/// access to it, and it can optionally dispose the notifier when it has no
/// more subscribers
///
/// Example:
/// ```dart
/// final counterManager = MMManager(
///   () => CounterNotifier(),
///   autodispose: true,
/// );
/// ```
class MMManager<T extends MMNotifier<dynamic>> {
  /// Creates a minimal manager for the given minimal notifier type
  ///
  /// The optional [autodispose] parameter dictates whether the notifier
  /// should be autodisposed or not (singleton case)
  MMManager(this._create, {this.autodispose = false});

  T? _instance;
  final T Function() _create;
  T Function()? _override;

  /// Whether the notifier should be disposed when it has no more subscribers
  final bool autodispose;

  /// Returns the notifier instance managed by this manager
  ///
  /// If no instance exists, a new one will be created. The same instance will
  ///  be returned on subsequent calls unless [autodispose] is true and the
  /// notifier was disposed
  ///
  /// Example:
  /// ```dart
  /// final counter = counterManager.notifier;
  /// counter.increment();
  /// ```
  T get notifier {
    final creator = _override ?? _create;
    _instance ??= creator()..onUnsubscribed = _onUnsubscribed;
    return _instance!;
  }

  /// Overrides the notifier factory for testing purposes
  ///
  /// This method is only available in tests and should not be used in
  /// production
  ///
  /// Example:
  /// ```dart
  /// chromaCounterManager.override(MockChromaCounterNotifier.new);
  /// ```
  @visibleForTesting
  void override(final T Function() override) {
    _override = override;
    _instance = null;
  }

  void _onUnsubscribed() {
    if (autodispose) {
      _instance?.dispose();
      _instance = null;
    }
  }
}
