import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/speaking/speak_missing_word/domain/entities/speak_missing_word_quest.dart';

abstract class SpeakMissingWordState extends Equatable {
  const SpeakMissingWordState();

  @override
  List<Object?> get props => [];
}

class SpeakMissingWordInitial extends SpeakMissingWordState {}

class SpeakMissingWordLoading extends SpeakMissingWordState {}

class SpeakMissingWordLoaded extends SpeakMissingWordState {
  final List<SpeakMissingWordQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const SpeakMissingWordLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  SpeakMissingWordQuest get currentQuest => quests[currentIndex];

  SpeakMissingWordLoaded copyWith({
    List<SpeakMissingWordQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return SpeakMissingWordLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
    );
  }

  @override
  List<Object?> get props => [quests, currentIndex, livesRemaining, lastAnswerCorrect];
}

class SpeakMissingWordGameComplete extends SpeakMissingWordState {
  final int xpEarned;
  final int coinsEarned;

  const SpeakMissingWordGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class SpeakMissingWordGameOver extends SpeakMissingWordState {}

class SpeakMissingWordError extends SpeakMissingWordState {
  final String message;

  const SpeakMissingWordError(this.message);

  @override
  List<Object?> get props => [message];
}
