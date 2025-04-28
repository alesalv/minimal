import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chroma_counter_state.dart';

class ChromaCounterCubit extends Cubit<ChromaCounterState> {
  ChromaCounterCubit() : super(const ChromaCounterState());

  static final _random = math.Random();

  void nextMetamorph() {
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
