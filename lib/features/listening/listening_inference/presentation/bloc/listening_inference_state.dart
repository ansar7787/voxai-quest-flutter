import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/listening/listening_inference/domain/entities/listening_inference_quest.dart';

abstract class ListeningInferenceState extends Equatable {
  const ListeningInferenceState();

  @override
  List<Object?> get props => [];
}

class ListeningInferenceInitial extends ListeningInferenceState {}

class ListeningInferenceLoading extends ListeningInferenceState {}

class ListeningInferenceLoaded extends ListeningInferenceState {
  final List<ListeningInferenceQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const ListeningInferenceLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  ListeningInferenceQuest get currentQuest => quests[currentIndex];

  ListeningInferenceLoaded copyWith({
    List<ListeningInferenceQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return ListeningInferenceLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
    );
  }

  @override
  List<Object?> get props => [
    quests,
    currentIndex,
    livesRemaining,
    lastAnswerCorrect,
  ];
}

class ListeningInferenceGameComplete extends ListeningInferenceState {
  final int xpEarned;
  final int coinsEarned;

  const ListeningInferenceGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class ListeningInferenceGameOver extends ListeningInferenceState {}

class ListeningInferenceError extends ListeningInferenceState {
  final String message;

  const ListeningInferenceError(this.message);

  @override
  List<Object?> get props => [message];
}
