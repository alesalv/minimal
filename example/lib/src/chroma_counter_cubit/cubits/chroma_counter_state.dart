part of 'chroma_counter_cubit.dart';
class ChromaCounterState {
  const ChromaCounterState({
    this.backgroundColor = Colors.blue,
    this.borderRadius = BorderRadius.zero,
    this.count = 0,
  }) : milestone = count ~/ 10;

  final Color backgroundColor;
  final BorderRadius borderRadius;
  final int count;
  final int milestone;
}
