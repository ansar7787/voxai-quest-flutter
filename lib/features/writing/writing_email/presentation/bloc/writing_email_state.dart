import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/writing/writing_email/domain/entities/writing_email_quest.dart';

abstract class WritingEmailState extends Equatable {
  const WritingEmailState();

  @override
  List<Object?> get props => [];
}

class WritingEmailInitial extends WritingEmailState {}

class WritingEmailLoading extends WritingEmailState {}

class WritingEmailLoaded extends WritingEmailState {
  final List<WritingEmailQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const WritingEmailLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  WritingEmailQuest get currentQuest => quests[currentIndex];

  WritingEmailLoaded copyWith({
    List<WritingEmailQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return WritingEmailLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      hintUsed: hintUsed ?? this.hintUsed,
    );
  }

  @override
  List<Object?> get props => [
    quests,
    currentIndex,
    livesRemaining,
    lastAnswerCorrect,
    hintUsed,
  ];
}

class WritingEmailGameComplete extends WritingEmailState {
  final int xpEarned;
  final int coinsEarned;

  const WritingEmailGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class WritingEmailGameOver extends WritingEmailState {}

class WritingEmailError extends WritingEmailState {
  final String message;

  const WritingEmailError(this.message);

  @override
  List<Object?> get props => [message];
}
