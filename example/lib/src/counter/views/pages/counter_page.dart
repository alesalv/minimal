import 'package:flutter/material.dart';

import '../../notifiers/counter_notifier.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            _CounterPanel(),
            _DisposableCounterPanel(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counterManager.notifier.increment();
          disposableCounterManager.notifier.increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CounterPanel extends StatelessWidget {
  const _CounterPanel();

  @override
  Widget build(final BuildContext context) {
    final notifier = counterManager.notifier;
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (final _, final state, final __) {
        return Column(
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              state.count.toString(),
              style: const TextStyle(fontSize: 48),
            ),
          ],
        );
      },
    );
  }
}

class _DisposableCounterPanel extends StatelessWidget {
  const _DisposableCounterPanel();

  @override
  Widget build(final BuildContext context) {
    final notifier = disposableCounterManager.notifier;
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (final _, final state, final __) {
        return Column(
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              state.count.toString(),
              style: const TextStyle(fontSize: 48),
            ),
          ],
        );
      },
    );
  }
}
