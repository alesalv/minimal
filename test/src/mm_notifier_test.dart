// Let's make the tests more readable and explicit
// ignore_for_file: cascade_invocations
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_mvn/minimal_mvn.dart';

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
  });

  group('MMNotifier select', () {
    test('cannot be mutated', () {
      var selectNotified = 0;
      void selectionL() => selectNotified++;

      final notifier = TNotifier();

      final selected = notifier.select((final state) => state.text);
      selected.addListener(selectionL);

      // ValueListenable is read-only, so it can't be mutated
      // ignore: unnecessary_type_check
      expect(selected is ValueListenable, true);
      notifier.append('parent update');
      expect(selected.value, 'parent update');
    });

    test('notifies listeners only when selection changes', () {
      var stateNotified = 0;
      void stateL() => stateNotified++;

      var selectNotified = 0;
      void selectionL() => selectNotified++;

      final notifier = TNotifier();
      notifier.addListener(stateL);

      // selected tracks changes in the text part of the state
      final selected = notifier.select((final state) => state.text);
      selected.addListener(selectionL);

      notifier.increment();
      expect(stateNotified, 1);
      // selected not notified
      expect(selected.value, '');
      expect(selectNotified, 0);

      notifier.increment();
      expect(stateNotified, 2);
      // selected not notified
      expect(selected.value, '');
      expect(selectNotified, 0);

      notifier.append('mutated');
      expect(stateNotified, 3);
      expect(notifier.state.value, 2);
      expect(notifier.state.text, 'mutated');
      // selected notified
      expect(selectNotified, 1);
      expect(selected.value, 'mutated');
    });

    test('stops notifying removed listeners', () {
      var stateNotified = 0;
      void stateL() => stateNotified++;

      var selectNotified = 0;
      void selectionL() => selectNotified++;

      final notifier = TNotifier();
      notifier.addListener(stateL);

      // selected tracks changes in the text part of the state
      final selected = notifier.select((final state) => state.text);
      selected.addListener(selectionL);

      notifier.append('one');
      expect(stateNotified, 1);
      // selected notified
      expect(selectNotified, 1);
      expect(selected.value, 'one');

      notifier.append('Two');
      expect(stateNotified, 2);
      // selected notified
      expect(selectNotified, 2);
      expect(selected.value, 'oneTwo');

      selected.removeListener(selectionL);

      notifier.append('Three');
      expect(stateNotified, 3);
      expect(notifier.state.value, 0);
      expect(notifier.state.text, 'oneTwoThree');
      // selected not notified
      expect(selectNotified, 2);
      expect(selected.value, 'oneTwo');
    });
  });

  group('MMNotifier dispose', () {
    test('state is tracked', () {
      final notifier = TNotifier();
      expect(notifier.isDisposed, false);

      notifier.dispose();
      expect(notifier.isDisposed, true);
    });

    test('when all listeners are removed', () {
      final manager = MMManager(
        TNotifier.new,
        autodispose: true,
      );

      var notified = 0;
      void l1() => notified++;
      void l2() => notified++;

      final notifier = manager.notifier;
      notifier.addListener(l1);
      notifier.addListener(l2);

      notifier.increment();
      notifier.increment();
      expect(notifier.isDisposed, false);

      notifier.removeListener(l1);
      expect(notifier.isDisposed, false);

      notifier.removeListener(l2);
      expect(notifier.isDisposed, true);
    });

    test('when all listeners are removed including selections', () {
      final manager = MMManager(
        TNotifier.new,
        autodispose: true,
      );

      var stateNotified = 0;
      void stateL() => stateNotified++;

      var selectNotified = 0;
      void selectionL() => selectNotified++;

      final notifier = manager.notifier;
      notifier.addListener(stateL);

      final selected = notifier.select((final state) => state.text);
      selected.addListener(selectionL);

      notifier.increment();
      notifier.append('mutated');
      expect(notifier.isDisposed, false);

      notifier.removeListener(stateL);
      expect(notifier.isDisposed, false);

      notifier.removeListener(selectionL);
      expect(notifier.isDisposed, true);
    });
  });
}
