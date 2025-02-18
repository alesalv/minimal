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
class MMManager<T extends MMNotifier> {
  /// Creates a minimal manager for the given minimal notifier type
  ///
  /// The optional [autodispose] parameter dictates whether the notifier
  /// should be autodisposed or not (singleton case)
  MMManager(this._create, {this.autodispose = false});

  T? _instance;

  final T Function() _create;

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
    _instance ??= _create()..onUnsubscribed = _onUnsubscribed;
    return _instance!;
  }

  void _onUnsubscribed() {
    if (autodispose) {
      _instance?.dispose();
      _instance = null;
    }
  }
}
