import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../notifiers/chroma_counter_notifier.dart';
import '../widgets/chroma_counter.dart';

class ChromaCounterPage extends StatelessWidget {
  const ChromaCounterPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chroma Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 32,
          children: [
            const _SelectedCount(),
            const ChromaCounter(),
            ElevatedButton(
              onPressed: () {
                unawaited(
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (final context) => const _BottomSheetContent(),
                    isScrollControlled: true,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.9,
                    ),
                    useSafeArea: true,
                  ),
                );
              },
              child: const Text('Reveal'),
            ),
          ],
        ),
      ),
      floatingActionButton: const _Button(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _SelectedCount extends StatelessWidget {
  const _SelectedCount();
  static final _formatter = DateFormat('mm:ss');

  @override
  Widget build(final BuildContext context) {
    final notifier = chromaCounterManager.notifier;

    return ListenableBuilder(
      listenable: notifier.select((final state) => state.milestone),
      builder: (final context, final _) {
        final now = _formatter.format(DateTime.now());
        return Text(
          'Selected: ${notifier.state.milestone} at $now',
          style: Theme.of(context).textTheme.titleMedium,
        );
      },
    );
  }
}

class _BottomSheetContent extends StatelessWidget {
  const _BottomSheetContent();

  @override
  Widget build(final BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 400,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: ChromaCounter(),
          ),
          Positioned(
            right: 16,
            bottom: 32,
            child: _Button(),
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button();

  @override
  Widget build(final BuildContext context) {
    return FloatingActionButton(
      onPressed: () => chromaCounterManager.notifier.nextMetamorph(),
      child: const Icon(Icons.refresh),
    );
  }
}
