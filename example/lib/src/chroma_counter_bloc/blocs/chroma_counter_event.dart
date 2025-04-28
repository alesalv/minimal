part of 'chroma_counter_bloc.dart';

sealed class ChromaCounterEvent {
  const ChromaCounterEvent();
}

final class NewMorphPressed extends ChromaCounterEvent {}
