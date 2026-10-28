import 'dart:async';

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

  var _disposed = false;
  // whether it got listeners since it was last unsubscribed
  var _listened = false;
  T _state;
  OnUnsubscribedCallback? _onUnsubscribed;

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
  ValueListenable<S> select<S>(final S Function(T state) selector) =>
      _MMSelector<T, S>(this, selector);

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

  /// Sets the callback to invoke when this notifier has no more subscribers
  ///
  /// Example:
  /// ```dart
  /// notifier.onUnsubscribed = () => print('No more subscribers');
  /// ```
  // ignore: avoid_setters_without_getters
  set onUnsubscribed(final OnUnsubscribedCallback cb) => _onUnsubscribed = cb;

  @override
  void addListener(final VoidCallback listener) {
    super.addListener(listener);
    _listened = true;
  }

  // ChangeNotifier ignores listeners which aren't registered, so relying on
  // hasListeners, rather than on a count, a listener removed twice, or never
  // added, doesn't count as an unsubscription
  @override
  void removeListener(final VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners && _listened) {
      _listened = false;
      _onUnsubscribed?.call();
    }
  }

  @override
  @mustCallSuper
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class _MMSelector<T, S> extends ChangeNotifier implements ValueListenable<S> {
  _MMSelector(this._parent, this._selector)
      : _source = _parent._state,
        _value = _selector(_parent._state) {
    _latest = this;
  }

  // the latest selection created, while it hasn't been listened yet
  static _MMSelector<dynamic, dynamic>? _latest;

  final MMNotifier<T> _parent;
  // always created by select() with the parent's own T
  // ignore: unsafe_variance
  final S Function(T state) _selector;
  S _value;
  // the parent's state the value was selected from
  T _source;
  var _listening = false;
  // whether listeners were removed since the last notification
  var _removedListeners = false;
  late final VoidCallback _onParentChanged = _select;

  // while not listening to the parent, the value may be stale
  @override
  S get value =>
      _listening || identical(_source, _parent._state) ? _value : _selector(_parent._state);

  void _select() {
    final state = _parent._state;
    _source = state;
    final value = _selector(state);
    if (_value == value) {
      return;
    }
    _value = value;
    notifyListeners();
    // listeners removed while being notified are dropped only afterwards
    if (_removedListeners) {
      _removedListeners = false;
      _checkUnlistened();
    }
  }

  @override
  void addListener(final VoidCallback listener) {
    // the moment selector is subscribed, start listening to the notifier for
    // its changes, catching up with the ones it missed
    if (!_listening) {
      final state = _parent._state;
      if (!identical(_source, state)) {
        _source = state;
        _value = _selector(state);
      }
      if (identical(_latest, this)) {
        _latest = null;
      }
      _listening = true;
      _parent.addListener(_onParentChanged);
    }
    super.addListener(listener);
  }

  @override
  void removeListener(final VoidCallback listener) {
    super.removeListener(listener);
    if (hasListeners) {
      _removedListeners = true;
    } else {
      _checkUnlistened();
    }
  }

  void _checkUnlistened() {
    // the moment selector is unsubscribed, stop listening to the notifier for
    // its changes
    if (!hasListeners && _listening) {
      // unless a new selection of the same autodispose notifier, not listened
      // yet, is most likely replacing this one, e.g. select() called in
      // build(): leaving first would momentarily unsubscribe the notifier,
      // which would be disposed. Then leave once it had the chance to subscribe
      if (identical(_latest?._parent, _parent) && _parent._onUnsubscribed != null) {
        scheduleMicrotask(_stopListening);
      } else {
        _stopListening();
      }
    }
  }

  void _stopListening() {
    if (!hasListeners && _listening) {
      _listening = false;
      _parent.removeListener(_onParentChanged);
    }
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
