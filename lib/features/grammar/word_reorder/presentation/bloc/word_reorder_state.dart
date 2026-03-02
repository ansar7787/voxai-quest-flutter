import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/grammar/word_reorder/domain/entities/word_reorder_quest.dart';

abstract class WordReorderState extends Equatable {
  const WordReorderState();

  @override
  List<Object?> get props => [];
}

class WordReorderInitial extends WordReorderState {}

class WordReorderLoading extends WordReorderState {}

class WordReorderLoaded extends WordReorderState {
  final List<WordReorderQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const WordReorderLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  WordReorderQuest get currentQuest => quests[currentIndex];

  WordReorderLoaded copyWith({
    List<WordReorderQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return WordReorderLoaded(
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

class WordReorderGameComplete extends WordReorderState {
  final int xpEarned;
  final int coinsEarned;

  const WordReorderGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class WordReorderGameOver extends WordReorderState {}

class WordReorderError extends WordReorderState {
  final String message;

  const WordReorderError(this.message);

  @override
  List<Object?> get props => [message];
}
