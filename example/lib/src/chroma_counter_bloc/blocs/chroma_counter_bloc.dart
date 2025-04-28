import 'dart:math' as math;

import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chroma_counter_event.dart';
part 'chroma_counter_state.dart';

class ChromaCounterBLoC extends Bloc<ChromaCounterEvent, ChromaCounterState> {
  ChromaCounterBLoC() : super(const ChromaCounterState()) {
    on<NewMorphPressed>(_onNewMorphPressed);
  }

  static final _random = math.Random();

  void _onNewMorphPressed(final NewMorphPressed event, final Emitter<ChromaCounterState> emit) {
    emit(
      ChromaCounterState(
        backgroundColor: _randomColor(),
        borderRadius: _randomRadius(),
        count: state.count + 1,
      ),
    );
  }

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
