import 'package:equatable/equatable.dart';

abstract class ListeningInferenceEvent extends Equatable {
  const ListeningInferenceEvent();

  @override
  List<Object?> get props => [];
}

class FetchListeningInferenceQuests extends ListeningInferenceEvent {
  final int level;

  const FetchListeningInferenceQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitListeningInferenceAnswer extends ListeningInferenceEvent {
  final int userIndex;
  final int correctIndex;

  const SubmitListeningInferenceAnswer({
    required this.userIndex,
    required this.correctIndex,
  });

  @override
  List<Object?> get props => [userIndex, correctIndex];
}

class NextListeningInferenceQuestion extends ListeningInferenceEvent {}

class RestoreListeningInferenceLife extends ListeningInferenceEvent {}
