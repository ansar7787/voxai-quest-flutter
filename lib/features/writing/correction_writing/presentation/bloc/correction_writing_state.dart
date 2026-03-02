import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/writing/correction_writing/domain/entities/correction_writing_quest.dart';

abstract class CorrectionWritingState extends Equatable {
  const CorrectionWritingState();

  @override
  List<Object?> get props => [];
}

class CorrectionWritingInitial extends CorrectionWritingState {}

class CorrectionWritingLoading extends CorrectionWritingState {}

class CorrectionWritingLoaded extends CorrectionWritingState {
  final List<CorrectionWritingQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const CorrectionWritingLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  CorrectionWritingQuest get currentQuest => quests[currentIndex];

  CorrectionWritingLoaded copyWith({
    List<CorrectionWritingQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return CorrectionWritingLoaded(
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

class CorrectionWritingGameComplete extends CorrectionWritingState {
  final int xpEarned;
  final int coinsEarned;

  const CorrectionWritingGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class CorrectionWritingGameOver extends CorrectionWritingState {}

class CorrectionWritingError extends CorrectionWritingState {
  final String message;

  const CorrectionWritingError(this.message);

  @override
  List<Object?> get props => [message];
}
