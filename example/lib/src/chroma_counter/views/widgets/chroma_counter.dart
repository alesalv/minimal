import 'package:flutter/material.dart';

import '../../notifiers/chroma_counter_notifier.dart';

class ChromaCounter extends StatelessWidget {
  const ChromaCounter({super.key});

  @override
  Widget build(final BuildContext context) {
    final notifier = chromaCounterManager.notifier;

    return ListenableBuilder(
      listenable: notifier,
      builder: (final _, final __) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: notifier.state.backgroundColor,
            borderRadius: notifier.state.borderRadius,
          ),
          child: Center(
            child: Text(
              '${notifier.state.count}',
              style: const TextStyle(
                fontSize: 48,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
