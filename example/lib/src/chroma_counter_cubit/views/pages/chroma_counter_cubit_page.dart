import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../cubits/chroma_counter_cubit.dart';
import '../widgets/chroma_counter.dart';

class ChromaCounterCubitPage extends StatelessWidget {
  const ChromaCounterCubitPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<ChromaCounterCubit>(
      create: (final _) => ChromaCounterCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chroma Counter Cubit'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 32,
            children: [
              _SelectedCount(),
              ChromaCounter(),
              _RevealButton(),
            ],
          ),
        ),
        floatingActionButton: const _Button(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class _SelectedCount extends StatelessWidget {
  const _SelectedCount();
  static final _formatter = DateFormat('mm:ss');

  @override
  Widget build(final BuildContext context) {
    final milestone = context.select<ChromaCounterCubit, int>(
      (final cubit) => cubit.state.milestone,
    );

    final now = _formatter.format(DateTime.now());
    return Text(
      'Selected: $milestone at $now',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class _RevealButton extends StatelessWidget {
  const _RevealButton();

  @override
  Widget build(final BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final cubit = context.read<ChromaCounterCubit>();
        unawaited(
          showModalBottomSheet<void>(
            context: context,
            builder: (final context) => BlocProvider.value(
              value: cubit,
              child: const _BottomSheetContent(),
            ),
            isScrollControlled: true,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            useSafeArea: true,
          ),
        );
      },
      child: const Text('Reveal'),
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
      onPressed: () => context.read<ChromaCounterCubit>().nextMetamorph(),
      child: const Icon(Icons.refresh),
    );
  }
}
