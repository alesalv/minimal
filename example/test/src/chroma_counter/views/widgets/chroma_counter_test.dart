import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_example/src/chroma_counter/notifiers/chroma_counter_notifier.dart';
import 'package:minimal_example/src/chroma_counter/views/widgets/chroma_counter.dart';

void main() {
  group('ChromaCounter', () {
    testWidgets('should update UI when state changes', (final tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChromaCounter(),
          ),
        ),
      );

      // Initial state
      expect(find.text('0'), findsOneWidget);
      final initialColor = _getContainerColor(tester);

      // Change state through notifier
      final notifier = chromaCounterManager.notifier;
      notifier.nextMetamorph();
      await tester.pump();

      // Verify changes
      expect(find.text('1'), findsOneWidget);
      final newColor = _getContainerColor(tester);
      expect(newColor, isNot(equals(initialColor)));
    });
  });
}

Color _getContainerColor(final WidgetTester tester) {
  final container = tester.widget<AnimatedContainer>(
    find.byType(AnimatedContainer),
  );
  final decoration = container.decoration as BoxDecoration;
  return decoration.color!;
}
