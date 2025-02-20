import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_example/src/chroma_counter/notifiers/chroma_counter_notifier.dart';
import 'package:minimal_example/src/chroma_counter/views/widgets/chroma_counter.dart';

void main() {
  group('ChromaCounter', () {
    testWidgets('should update UI when state changes', (final tester) async {
      // Use the minimal manager to override the notifier
      chromaCounterManager.override(MockChromaCounterNotifier.new);

      await tester.pumpWidget(const MaterialApp(home: ChromaCounter()));

      expect(find.text('0'), findsOneWidget);
      final initialColor = _getContainerColor(tester);
      expect(initialColor, equals(Colors.blue));

      // Change state through the mock notifier
      chromaCounterManager.notifier.nextMetamorph();
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      final newColor = _getContainerColor(tester);
      expect(newColor, isNot(equals(initialColor)));
      // Test the exact color instead of a random one
      expect(newColor, equals(Colors.red));
    });
  });
}

Color _getContainerColor(final WidgetTester tester) {
  final container = tester.widget<AnimatedContainer>(
    find.byType(AnimatedContainer),
  );
  final decoration = container.decoration! as BoxDecoration;
  return decoration.color!;
}

/// A mock [ChromaCounterNotifier] that uses predictable colors for testing
/// purposes
class MockChromaCounterNotifier extends ChromaCounterNotifier {
  @override
  void nextMetamorph() {
    notify(
      state.copyWith(
        backgroundColor: Colors.red, // Predictable color
        count: state.count + 1,
      ),
    );
  }
}
