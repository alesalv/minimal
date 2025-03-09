import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'chroma_counter_ui_state.mapper.dart';

@MappableClass()
class ChromaCounterUIState with ChromaCounterUIStateMappable {
  const ChromaCounterUIState({
    this.backgroundColor = Colors.blue,
    this.borderRadius = BorderRadius.zero,
    this.count = 0,
  }) : milestone = count ~/ 10;

  final Color backgroundColor;
  final BorderRadius borderRadius;
  final int count;
  final int milestone;
}
