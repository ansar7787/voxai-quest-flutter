import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/writing/complete_sentence/domain/entities/complete_sentence_quest.dart';

abstract class CompleteSentenceState extends Equatable {
  const CompleteSentenceState();

  @override
  List<Object?> get props => [];
}

class CompleteSentenceInitial extends CompleteSentenceState {}

class CompleteSentenceLoading extends CompleteSentenceState {}

class CompleteSentenceLoaded extends CompleteSentenceState {
  final List<CompleteSentenceQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const CompleteSentenceLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  CompleteSentenceQuest get currentQuest => quests[currentIndex];

  CompleteSentenceLoaded copyWith({
    List<CompleteSentenceQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return CompleteSentenceLoaded(
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

class CompleteSentenceGameComplete extends CompleteSentenceState {
  final int xpEarned;
  final int coinsEarned;

  const CompleteSentenceGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class CompleteSentenceGameOver extends CompleteSentenceState {}

class CompleteSentenceError extends CompleteSentenceState {
  final String message;

  const CompleteSentenceError(this.message);

  @override
  List<Object?> get props => [message];
}
