import 'package:flutter/foundation.dart';

/// Callback invoked when a notifier has no more subscribers
typedef OnUnsubscribedCallback = void Function();

/// Minimal notifier for the MVN (Model-View-Notifier) pattern
///
/// A minimal notifier manages state and business logic. It extends
/// [ChangeNotifier] to notify widgets when the state changes
///
/// Example:
/// ```dart
/// class CounterNotifier extends MMNotifier<CounterState> {
///   CounterNotifier() : super(const CounterState(count: 0));
///
///   void increment() => notify(state.copyWith(count: state.count + 1));
/// }
/// ```
abstract class MMNotifier<T> extends ChangeNotifier {
  /// Creates a minimal notifier with the given initial state
  MMNotifier(this._state);

  var _listenersCount = 0;
  var _disposed = false;
  T _state;

  /// Whether this notifier has been disposed. Subclasses can check this before
  /// performing asynchronous operations that might occur after disposal
  ///
  /// Example:
  /// ```dart
  /// void increment() {
  ///   if (disposed) return;
  ///   notify(state.copyWith(value: state.value + 1));
  /// }
  /// ```
  @protected
  bool get disposed => _disposed;

  /// The current state managed by this notifier
  ///
  /// This getter provides read-only access to the current state. To update
  /// the state, use [notify] instead
  ///
  /// Example:
  /// ```dart
  /// final notifier = counterManager.notifier;
  /// print(notifier.state.count);
  /// ```
  T get state => _state;

  /// Selects part of the state, so that only the selected part is notified
  /// when it changes
  ///
  /// This is useful for optimizing rebuilds in the UI. The returned
  /// [ValueListenable] will only notify its listeners when the selected value
  /// actually changes
  ///
  /// Example:
  /// ```dart
  /// // Only rebuilds when backgroundColor changes
  /// final colorNotifier = notifier.select((state) => state.backgroundColor);
  /// return ListenableBuilder(
  ///   listenable: colorNotifier,
  ///   builder: (context, _) => Container(
  ///     color: colorNotifier.value,
  ///     child: Text('Color changed!'),
  ///   ),
  /// );
  /// ```
  ValueListenable<S> select<S>(final S Function(T state) selector) {
    final notifier = _MMSelector(() => selector(_state));
    // the moment selector is subscribed, start listening to the notifier
    // for its changes
    notifier.onAddListener = () => addListener(notifier.notify);
    // the moment selector is unsubscribed, stop listening to the notifier
    // for its changes
    // ignore: cascade_invocations
    notifier.onRemoveListener = () => removeListener(notifier.notify);
    return notifier;
  }

  /// Mutates the notifier's state and notifies its listeners
  ///
  /// This is the preferred way to update state as it ensures all listeners
  /// are notified. In case the new state is the same as the current state,
  /// the notification is skipped to avoid unnecessary rebuilds
  ///
  /// Example:
  /// ```dart
  /// void increment() => notify(state.copyWith(value: state.value + 1));
  /// ```
  @protected
  void notify(final T value) {
    if (_state != value) {
      _state = value;
      notifyListeners();
    }
  }

  /// Callback that will be invoked when this notifier has no more
  /// subscribers. There shouldn't be any reason to use this callback directly
  OnUnsubscribedCallback? onUnsubscribed;

  @override
  void addListener(final VoidCallback listener) {
    super.addListener(listener);
    _listenersCount++;
  }

  @override
  void removeListener(final VoidCallback listener) {
    super.removeListener(listener);
    _listenersCount--;
    if (_listenersCount <= 0) {
      _listenersCount = 0;
      onUnsubscribed?.call();
    }
  }

  @override
  @mustCallSuper
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class _MMSelector<T> extends ValueNotifier<T> {
  _MMSelector(this._getValue) : super(_getValue());

  final T Function() _getValue;
  VoidCallback? onAddListener;
  VoidCallback? onRemoveListener;

  void notify() {
    value = _getValue();
  }

  @override
  void addListener(final VoidCallback listener) {
    onAddListener?.call();
    super.addListener(listener);
  }

  @override
  void removeListener(final VoidCallback listener) {
    onRemoveListener?.call();
    super.removeListener(listener);
  }
}
