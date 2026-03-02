import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/vocabulary/academic_word/domain/entities/academic_word_quest.dart';

abstract class AcademicWordState extends Equatable {
  const AcademicWordState();

  @override
  List<Object?> get props => [];
}

class AcademicWordInitial extends AcademicWordState {}

class AcademicWordLoading extends AcademicWordState {}

class AcademicWordLoaded extends AcademicWordState {
  final List<AcademicWordQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const AcademicWordLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  AcademicWordQuest get currentQuest => quests[currentIndex];

  AcademicWordLoaded copyWith({
    List<AcademicWordQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return AcademicWordLoaded(
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

class AcademicWordGameComplete extends AcademicWordState {
  final int xpEarned;
  final int coinsEarned;

  const AcademicWordGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class AcademicWordGameOver extends AcademicWordState {}

class AcademicWordError extends AcademicWordState {
  final String message;

  const AcademicWordError(this.message);

  @override
  List<Object?> get props => [message];
}
