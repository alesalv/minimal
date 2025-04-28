part of 'chroma_counter_bloc.dart';

class ChromaCounterState extends Equatable {
  const ChromaCounterState({
    this.backgroundColor = Colors.blue,
    this.borderRadius = BorderRadius.zero,
    this.count = 0,
  }) : milestone = count ~/ 10;

  final Color backgroundColor;
  final BorderRadius borderRadius;
  final int count;
  final int milestone;

  @override
  List<Object?> get props => [backgroundColor, borderRadius, count, milestone];
}
