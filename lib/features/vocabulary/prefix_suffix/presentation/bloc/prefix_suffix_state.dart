import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/vocabulary/prefix_suffix/domain/entities/prefix_suffix_quest.dart';

abstract class PrefixSuffixState extends Equatable {
  const PrefixSuffixState();

  @override
  List<Object?> get props => [];
}

class PrefixSuffixInitial extends PrefixSuffixState {}

class PrefixSuffixLoading extends PrefixSuffixState {}

class PrefixSuffixLoaded extends PrefixSuffixState {
  final List<PrefixSuffixQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const PrefixSuffixLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  PrefixSuffixQuest get currentQuest => quests[currentIndex];

  PrefixSuffixLoaded copyWith({
    List<PrefixSuffixQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return PrefixSuffixLoaded(
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

class PrefixSuffixGameComplete extends PrefixSuffixState {
  final int xpEarned;
  final int coinsEarned;

  const PrefixSuffixGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class PrefixSuffixGameOver extends PrefixSuffixState {}

class PrefixSuffixError extends PrefixSuffixState {
  final String message;

  const PrefixSuffixError(this.message);

  @override
  List<Object?> get props => [message];
}
