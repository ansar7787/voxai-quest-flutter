import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/reading/guess_title/domain/entities/guess_title_quest.dart';

abstract class GuessTitleState extends Equatable {
  const GuessTitleState();

  @override
  List<Object?> get props => [];
}

class GuessTitleInitial extends GuessTitleState {}

class GuessTitleLoading extends GuessTitleState {}

class GuessTitleLoaded extends GuessTitleState {
  final List<GuessTitleQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const GuessTitleLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  GuessTitleQuest get currentQuest => quests[currentIndex];

  GuessTitleLoaded copyWith({
    List<GuessTitleQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return GuessTitleLoaded(
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

class GuessTitleGameComplete extends GuessTitleState {
  final int xpEarned;
  final int coinsEarned;

  const GuessTitleGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class GuessTitleGameOver extends GuessTitleState {}

class GuessTitleError extends GuessTitleState {
  final String message;

  const GuessTitleError(this.message);

  @override
  List<Object?> get props => [message];
}
