import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/speaking/pronunciation_focus/domain/entities/pronunciation_focus_quest.dart';

abstract class PronunciationFocusState extends Equatable {
  const PronunciationFocusState();

  @override
  List<Object?> get props => [];
}

class PronunciationFocusInitial extends PronunciationFocusState {}

class PronunciationFocusLoading extends PronunciationFocusState {}

class PronunciationFocusLoaded extends PronunciationFocusState {
  final List<PronunciationFocusQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final double? lastAccuracyScore;

  const PronunciationFocusLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.lastAccuracyScore,
  });

  PronunciationFocusQuest get currentQuest => quests[currentIndex];

  PronunciationFocusLoaded copyWith({
    List<PronunciationFocusQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    double? lastAccuracyScore,
  }) {
    return PronunciationFocusLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      lastAccuracyScore: lastAccuracyScore,
    );
  }

  @override
  List<Object?> get props => [quests, currentIndex, livesRemaining, lastAnswerCorrect, lastAccuracyScore];
}

class PronunciationFocusGameComplete extends PronunciationFocusState {
  final int xpEarned;
  final int coinsEarned;

  const PronunciationFocusGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class PronunciationFocusGameOver extends PronunciationFocusState {}

class PronunciationFocusError extends PronunciationFocusState {
  final String message;

  const PronunciationFocusError(this.message);

  @override
  List<Object?> get props => [message];
}
