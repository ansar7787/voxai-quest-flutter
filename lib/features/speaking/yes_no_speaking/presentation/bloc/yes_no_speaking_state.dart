import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/speaking/yes_no_speaking/domain/entities/yes_no_speaking_quest.dart';

abstract class YesNoSpeakingState extends Equatable {
  const YesNoSpeakingState();

  @override
  List<Object?> get props => [];
}

class YesNoSpeakingInitial extends YesNoSpeakingState {}

class YesNoSpeakingLoading extends YesNoSpeakingState {}

class YesNoSpeakingLoaded extends YesNoSpeakingState {
  final List<YesNoSpeakingQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const YesNoSpeakingLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  YesNoSpeakingQuest get currentQuest => quests[currentIndex];

  YesNoSpeakingLoaded copyWith({
    List<YesNoSpeakingQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return YesNoSpeakingLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
    );
  }

  @override
  List<Object?> get props => [
    quests,
    currentIndex,
    livesRemaining,
    lastAnswerCorrect,
  ];
}

class YesNoSpeakingGameComplete extends YesNoSpeakingState {
  final int xpEarned;
  final int coinsEarned;

  const YesNoSpeakingGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class YesNoSpeakingGameOver extends YesNoSpeakingState {}

class YesNoSpeakingError extends YesNoSpeakingState {
  final String message;

  const YesNoSpeakingError(this.message);

  @override
  List<Object?> get props => [message];
}
