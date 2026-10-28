// Let's make the tests more readable and explicit
// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_mvn/minimal_mvn.dart';

import 'utils/test_common.dart';

void main() {
  group('MMManager', () {
    test('creates notifier lazily', () {
      var created = 0;
      final manager = MMManager(() {
        created++;
        return TNotifier();
      });
      expect(created, 0);
      manager.notifier;
      expect(created, 1);
      manager.notifier;
      expect(created, 1);
    });

    test('keeps instance when autodispose is false (singleton)', () {
      final manager = MMManager(TNotifier.new);
      final first = manager.notifier;
      first.increment();

      // Adding and removing a listener triggers disposing the notifier
      void l() {}
      first
        ..addListener(l)
        ..removeListener(l);

      final second = manager.notifier;

      expect(second, same(first));
      expect(second.state.value, 1);
    });

    test('disposes instance when autodispose is true', () {
      final manager = MMManager(
        TNotifier.new,
        autodispose: true,
      );

      final first = manager.notifier;
      first.increment();

      // Adding and removing a listener triggers disposing the notifier
      void l() {}
      first
        ..addListener(l)
        ..removeListener(l);

      final second = manager.notifier;

      expect(second, isNot(same(first)));
      expect(second.state.value, 0);
    });

    test('does not dispose the current instance when a stale one is unsubscribed', () {
      final manager = MMManager(
        TNotifier.new,
        autodispose: true,
      );

      final stale = manager.notifier;
      void l1() {}
      stale.addListener(l1);

      // replaces the instance, while the stale one is still listened
      manager.override(TNotifier.new);
      final current = manager.notifier;
      void l2() {}
      current.addListener(l2);

      stale.removeListener(l1);
      expect(stale.isDisposed, true);
      expect(current.isDisposed, false);
      expect(manager.notifier, same(current));
    });

    test('throws an error when accessing notifier after disposal', () {
      final manager = MMManager(
        TNotifier.new,
        autodispose: true,
      );

      final notifier = manager.notifier;
      notifier.increment();

      // Adding and removing a listener triggers disposing the notifier
      void l() {}
      notifier
        ..addListener(l)
        ..removeListener(l);

      expect(
        notifier.increment,
        throwsA(isA<FlutterError>()),
        reason: 'Accessing notifier after disposal will throw an error',
      );
    });
  });
}
