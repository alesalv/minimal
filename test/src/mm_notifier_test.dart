// Let's make the tests more readable and explicit
// ignore_for_file: cascade_invocations
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_common.dart';

void main() {
  group('MMNotifier', () {
    test('notifies listeners upon state changes', () {
      var notified = 0;
      void l() => notified++;

      final notifier = TNotifier();
      notifier.addListener(l);
      expect(notified, 0);
      expect(notifier.state.value, 0);

      notifier.increment();
      expect(notified, 1);
      expect(notifier.state.value, 1);

      notifier.increment();
      expect(notified, 2);
      expect(notifier.state.value, 2);
    });

    test('stops notifying removed listeners', () {
      var notified = 0;
      void l() => notified++;

      final notifier = TNotifier();
      notifier.addListener(l);
      expect(notified, 0);
      expect(notifier.state.value, 0);

      notifier.increment();
      expect(notified, 1);
      expect(notifier.state.value, 1);

      notifier.removeListener(l);
      notifier.increment();
      expect(notified, 1);
      expect(notifier.state.value, 2);
    });

    test('selects part of state', () {
      var stateNotified = 0;
      void stateL() => stateNotified++;

      var selectionNotified = 0;
      void selectionL() => selectionNotified++;

      final notifier = TNotifier();
      notifier.addListener(stateL);

      final selected = notifier.select((final state) => state.text);
      selected.addListener(selectionL);

      notifier.increment();
      expect(selected.value, '');
      expect(notifier.state.value, 1);
      expect(notifier.state.text, '');
      expect(stateNotified, 1);
      expect(selectionNotified, 0);

      notifier.increment();
      expect(selected.value, '');
      expect(notifier.state.value, 2);
      expect(notifier.state.text, '');
      expect(stateNotified, 2);
      expect(selectionNotified, 0);

      notifier.append('mutated');
      expect(selected.value, 'mutated');
      expect(notifier.state.value, 2);
      expect(notifier.state.text, 'mutated');
      expect(stateNotified, 3);
      expect(selectionNotified, 1);
    });

    test('selection cannot be mutated', () {
      var selectionNotified = 0;
      void selectionL() => selectionNotified++;

      final notifier = TNotifier();

      final selected = notifier.select((final state) => state.text);
      selected.addListener(selectionL);

      // ValueListenable is read-only, so we can't mutate it
      // ignore: unnecessary_type_check
      expect(selected is ValueListenable, true);
      notifier.append('parent update');
      expect(selected.value, 'parent update');
    });

    test('tracks disposed state', () {
      final notifier = TNotifier();
      expect(notifier.isDisposed, false);

      notifier.dispose();
      expect(notifier.isDisposed, true);
    });
  });
}
