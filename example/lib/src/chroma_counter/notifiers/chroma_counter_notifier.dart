import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:minimal_mvn/minimal_mvn.dart';
import '../views/ui_states/chroma_counter_ui_state.dart';

class ChromaCounterNotifier extends MMNotifier<ChromaCounterUIState> {
  ChromaCounterNotifier() : super(const ChromaCounterUIState());

  static final _random = math.Random();

  void nextMetamorph() => notify(
        state.copyWith(
          count: state.count + 1,
          backgroundColor: _randomColor(),
          borderRadius: _randomRadius(),
        ),
      );

  Color _randomColor() => Color.fromRGBO(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        1,
      );

  BorderRadius _randomRadius() => BorderRadius.only(
        topLeft: Radius.circular(_random.nextDouble() * 100),
        topRight: Radius.circular(_random.nextDouble() * 100),
        bottomLeft: Radius.circular(_random.nextDouble() * 100),
        bottomRight: Radius.circular(_random.nextDouble() * 100),
      );
}

final MMManager<ChromaCounterNotifier> chromaCounterManager =
    MMManager(ChromaCounterNotifier.new, autodispose: true);
