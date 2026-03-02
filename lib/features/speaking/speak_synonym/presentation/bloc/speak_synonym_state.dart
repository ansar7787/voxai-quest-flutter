import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/speaking/speak_synonym/domain/entities/speak_synonym_quest.dart';

abstract class SpeakSynonymState extends Equatable {
  const SpeakSynonymState();

  @override
  List<Object?> get props => [];
}

class SpeakSynonymInitial extends SpeakSynonymState {}

class SpeakSynonymLoading extends SpeakSynonymState {}

class SpeakSynonymLoaded extends SpeakSynonymState {
  final List<SpeakSynonymQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const SpeakSynonymLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  SpeakSynonymQuest get currentQuest => quests[currentIndex];

  SpeakSynonymLoaded copyWith({
    List<SpeakSynonymQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return SpeakSynonymLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
    );
  }

  @override
  List<Object?> get props => [quests, currentIndex, livesRemaining, lastAnswerCorrect];
}

class SpeakSynonymGameComplete extends SpeakSynonymState {
  final int xpEarned;
  final int coinsEarned;

  const SpeakSynonymGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class SpeakSynonymGameOver extends SpeakSynonymState {}

class SpeakSynonymError extends SpeakSynonymState {
  final String message;

  const SpeakSynonymError(this.message);

  @override
  List<Object?> get props => [message];
}
