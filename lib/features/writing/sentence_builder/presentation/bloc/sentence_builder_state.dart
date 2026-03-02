import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/writing/sentence_builder/domain/entities/sentence_builder_quest.dart';

abstract class SentenceBuilderState extends Equatable {
  const SentenceBuilderState();

  @override
  List<Object?> get props => [];
}

class SentenceBuilderInitial extends SentenceBuilderState {}

class SentenceBuilderLoading extends SentenceBuilderState {}

class SentenceBuilderLoaded extends SentenceBuilderState {
  final List<SentenceBuilderQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const SentenceBuilderLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  SentenceBuilderQuest get currentQuest => quests[currentIndex];

  SentenceBuilderLoaded copyWith({
    List<SentenceBuilderQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return SentenceBuilderLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      hintUsed: hintUsed ?? this.hintUsed,
    );
  }

  @override
  List<Object?> get props => [quests, currentIndex, livesRemaining, lastAnswerCorrect, hintUsed];
}

class SentenceBuilderGameComplete extends SentenceBuilderState {
  final int xpEarned;
  final int coinsEarned;

  const SentenceBuilderGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class SentenceBuilderGameOver extends SentenceBuilderState {}

class SentenceBuilderError extends SentenceBuilderState {
  final String message;

  const SentenceBuilderError(this.message);

  @override
  List<Object?> get props => [message];
}
