import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/chroma_counter_bloc.dart';

class ChromaCounter extends StatelessWidget {
  const ChromaCounter({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<ChromaCounterBLoC, ChromaCounterState>(
      builder: (final context, final state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: state.backgroundColor,
            borderRadius: state.borderRadius,
          ),
          child: Center(
            child: Text(
              '${state.count}',
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
