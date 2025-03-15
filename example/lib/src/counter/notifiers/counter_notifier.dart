import 'package:minimal_mvn/minimal_mvn.dart';

class CounterNotifier extends MMNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => notify(state + 1);
}

final MMManager<CounterNotifier> counterManager = MMManager(CounterNotifier.new);

final MMManager<CounterNotifier> disposableCounterManager =
    MMManager(CounterNotifier.new, autodispose: true);
