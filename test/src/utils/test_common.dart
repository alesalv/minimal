import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_mvn/minimal_mvn.dart';

/// Collects the errors reported to [FlutterError.onError] during a test, e.g.
/// the ones thrown by listeners, which ChangeNotifier catches and reports
List<FlutterErrorDetails> trackFlutterErrors() {
  final errors = <FlutterErrorDetails>[];
  final onError = FlutterError.onError;
  FlutterError.onError = errors.add;
  addTearDown(() => FlutterError.onError = onError);
  return errors;
}

@immutable
class TState {
  const TState({
    required this.value,
    required this.text,
  });

  final int value;
  final String text;

  TState copyWith({
    final int? value,
    final String? text,
  }) =>
      TState(
        value: value ?? this.value,
        text: text ?? this.text,
      );

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is TState &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          text == other.text;

  @override
  int get hashCode => Object.hash(value, text);
}

class TNotifier extends MMNotifier<TState> {
  TNotifier() : super(const TState(value: 0, text: ''));

  void increment() => notify(state.copyWith(value: state.value + 1));

  void append(final String suffix) => notify(state.copyWith(text: '${state.text}$suffix'));

  bool get isDisposed => disposed;
}
