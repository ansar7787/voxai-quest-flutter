import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/vocabulary/idioms/domain/entities/idioms_quest.dart';

abstract class IdiomsState extends Equatable {
  const IdiomsState();

  @override
  List<Object?> get props => [];
}

class IdiomsInitial extends IdiomsState {}

class IdiomsLoading extends IdiomsState {}

class IdiomsLoaded extends IdiomsState {
  final List<IdiomsQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const IdiomsLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  IdiomsQuest get currentQuest => quests[currentIndex];

  IdiomsLoaded copyWith({
    List<IdiomsQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return IdiomsLoaded(
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

class IdiomsGameComplete extends IdiomsState {
  final int xpEarned;
  final int coinsEarned;

  const IdiomsGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class IdiomsGameOver extends IdiomsState {}

class IdiomsError extends IdiomsState {
  final String message;

  const IdiomsError(this.message);

  @override
  List<Object?> get props => [message];
}
