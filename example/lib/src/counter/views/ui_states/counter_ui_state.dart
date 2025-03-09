import 'package:dart_mappable/dart_mappable.dart';

part 'counter_ui_state.mapper.dart';

@MappableClass()
class CounterUIState with CounterUIStateMappable {
  const CounterUIState({
    required this.count,
  });

  final int count;
}
