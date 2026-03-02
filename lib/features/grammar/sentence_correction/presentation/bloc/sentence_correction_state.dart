import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/grammar/sentence_correction/domain/entities/sentence_correction_quest.dart';

abstract class SentenceCorrectionState extends Equatable {
  const SentenceCorrectionState();

  @override
  List<Object?> get props => [];
}

class SentenceCorrectionInitial extends SentenceCorrectionState {}

class SentenceCorrectionLoading extends SentenceCorrectionState {}

class SentenceCorrectionLoaded extends SentenceCorrectionState {
  final List<SentenceCorrectionQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const SentenceCorrectionLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  SentenceCorrectionQuest get currentQuest => quests[currentIndex];

  SentenceCorrectionLoaded copyWith({
    List<SentenceCorrectionQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return SentenceCorrectionLoaded(
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

class SentenceCorrectionGameComplete extends SentenceCorrectionState {
  final int xpEarned;
  final int coinsEarned;

  const SentenceCorrectionGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class SentenceCorrectionGameOver extends SentenceCorrectionState {}

class SentenceCorrectionError extends SentenceCorrectionState {
  final String message;

  const SentenceCorrectionError(this.message);

  @override
  List<Object?> get props => [message];
}
