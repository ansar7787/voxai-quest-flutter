import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/grammar/grammar_quest/domain/entities/grammar_quest_quest.dart';

abstract class GrammarQuestState extends Equatable {
  const GrammarQuestState();

  @override
  List<Object?> get props => [];
}

class GrammarQuestInitial extends GrammarQuestState {}

class GrammarQuestLoading extends GrammarQuestState {}

class GrammarQuestLoaded extends GrammarQuestState {
  final List<GrammarQuestQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const GrammarQuestLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  GrammarQuestQuest get currentQuest => quests[currentIndex];

  GrammarQuestLoaded copyWith({
    List<GrammarQuestQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return GrammarQuestLoaded(
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

class GrammarQuestGameComplete extends GrammarQuestState {
  final int xpEarned;
  final int coinsEarned;

  const GrammarQuestGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class GrammarQuestGameOver extends GrammarQuestState {}

class GrammarQuestError extends GrammarQuestState {
  final String message;

  const GrammarQuestError(this.message);

  @override
  List<Object?> get props => [message];
}
