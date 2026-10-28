// Let's make the tests more readable and explicit
// ignore_for_file: cascade_invocations
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      // but its value still reflects the current state
      expect(selected.value, 'oneTwoThree');
    });

    test('value is up to date after re-subscribing', () async {
      final notifier = TNotifier();
      final selected = notifier.select((final state) => state.text);

      void selectionL() {}
      selected.addListener(selectionL);
      selected.removeListener(selectionL);
      await Future<void>.delayed(Duration.zero);

      // changes while the selection has no listeners
      notifier.append('unobserved');
      // read before subscribing, as ValueListenableBuilder does
      expect(selected.value, 'unobserved');

      selected.addListener(selectionL);
      expect(selected.value, 'unobserved');
    });

    test('stops listening to the notifier right away when others listen', () {
      var selections = 0;
      final notifier = TNotifier();
      final selected = notifier.select((final state) {
        selections++;
        return state.text;
      });

      void stateL() {}
      void selectionL() {}
      notifier.addListener(stateL);
      selected.addListener(selectionL);
      selected.removeListener(selectionL);

      selections = 0;
      notifier.append('unobserved');
      expect(selections, 0);
    });

    test('listens to the notifier once regardless of its listeners', () {
      var selections = 0;
      final notifier = TNotifier();
      final selected = notifier.select((final state) {
        selections++;
        return state.text;
      });

      void selectionL1() {}
      void selectionL2() {}
      selected.addListener(selectionL1);
      selected.addListener(selectionL2);

      selections = 0;
      notifier.append('once');
      expect(selections, 1);
    });

    testWidgets('survives rebuilds when called in build', (final tester) async {
      final manager = MMManager(TNotifier.new, autodispose: true);
      late StateSetter rebuild;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (final context, final setState) {
              rebuild = setState;
              final notifier = manager.notifier;
              // a new selection is created on every build, the only
              // subscriber to the notifier
              return ListenableBuilder(
                listenable: notifier.select((final state) => state.value),
                builder: (final _, final __) => Text('${notifier.state.value}'),
              );
            },
          ),
        ),
      );

      manager.notifier.increment();
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      // swapping selections must not autodispose the notifier
      rebuild(() {});
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text('1'), findsOneWidget);

      manager.notifier.increment();
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
    });
  });

  group('MMNotifier onUnsubscribed', () {
    test('calls onUnsubscribed when all listeners are removed', () {
      var called = false;
      final notifier = TNotifier();
      notifier.onUnsubscribed = () => called = true;

      void l() {}
      notifier.addListener(l);
      expect(called, false);

      notifier.removeListener(l);
      expect(called, true);
    });

    test('does not call onUnsubscribed when some listeners remain', () {
      var called = false;
      final notifier = TNotifier();
      notifier.onUnsubscribed = () => called = true;

      void l1() {}
      void l2() {}
      notifier.addListener(l1);
      notifier.addListener(l2);

      notifier.removeListener(l1);
      expect(called, false);
    });

    test('does not call onUnsubscribed when removing a listener never added', () {
      var called = false;
      final notifier = TNotifier();
      notifier.onUnsubscribed = () => called = true;

      void l1() {}
      void l2() {}
      notifier.addListener(l1);

      notifier.removeListener(l2);
      expect(called, false);
    });

    test('does not call onUnsubscribed when removing a listener twice', () {
      var called = false;
      final notifier = TNotifier();
      notifier.onUnsubscribed = () => called = true;

      void l1() {}
      void l2() {}
      notifier.addListener(l1);
      notifier.addListener(l2);

      notifier.removeListener(l1);
      notifier.removeListener(l1);
      expect(called, false);
    });

    test('counts a listener added twice as two subscriptions', () {
      var called = false;
      final notifier = TNotifier();
      notifier.onUnsubscribed = () => called = true;

      void l() {}
      notifier.addListener(l);
      notifier.addListener(l);

      notifier.removeListener(l);
      expect(called, false);

      notifier.removeListener(l);
      expect(called, true);
    });

    test('calls onUnsubscribed once', () {
      var called = 0;
      final notifier = TNotifier();
      notifier.onUnsubscribed = () => called++;

      void l() {}
      notifier.addListener(l);

      notifier.removeListener(l);
      notifier.removeListener(l);
      expect(called, 1);
    });

    test('does not call onUnsubscribed when removing a selection listener never added', () {
      var called = false;
      final notifier = TNotifier();
      notifier.onUnsubscribed = () => called = true;

      void selectionL1() {}
      void selectionL2() {}
      final selected = notifier.select((final state) => state.text);
      selected.addListener(selectionL1);

      selected.removeListener(selectionL2);
      expect(called, false);
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

    test('not when a listener never added is removed', () {
      final manager = MMManager(
        TNotifier.new,
        autodispose: true,
      );

      void l1() {}
      void l2() {}

      final notifier = manager.notifier;
      notifier.addListener(l1);

      notifier.removeListener(l2);
      expect(notifier.isDisposed, false);

      notifier.removeListener(l1);
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

      // selectionL is a listener of the selection, not of the notifier
      notifier.removeListener(selectionL);
      expect(notifier.isDisposed, false);

      selected.removeListener(selectionL);
      expect(notifier.isDisposed, true);
    });

    test('not while notifying, when the last listener removes itself', () {
      final manager = MMManager(
        TNotifier.new,
        autodispose: true,
      );

      final errors = trackFlutterErrors();
      final notifier = manager.notifier;
      var notified = 0;
      late VoidCallback once;
      once = () {
        notified++;
        notifier.removeListener(once);
      };
      notifier.addListener(once);

      // disposing while notifying would throw
      notifier.increment();
      expect(notified, 1);
      expect(errors, isEmpty);
      expect(notifier.isDisposed, false);

      // it's disposed with its next unsubscription
      void l() {}
      notifier.addListener(l);
      notifier.removeListener(l);
      expect(notifier.isDisposed, true);
    });

    test('not while notifying, when the last selection listener removes itself', () {
      final manager = MMManager(
        TNotifier.new,
        autodispose: true,
      );

      final errors = trackFlutterErrors();
      final notifier = manager.notifier;
      final selected = notifier.select((final state) => state.value);
      late VoidCallback once;
      once = () => selected.removeListener(once);
      selected.addListener(once);

      notifier.increment();
      expect(errors, isEmpty);
      expect(notifier.isDisposed, false);

      void l() {}
      selected.addListener(l);
      selected.removeListener(l);
      expect(notifier.isDisposed, true);
    });
  });
}
