import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/grammar/clause_connector/domain/entities/clause_connector_quest.dart';

abstract class ClauseConnectorState extends Equatable {
  const ClauseConnectorState();

  @override
  List<Object?> get props => [];
}

class ClauseConnectorInitial extends ClauseConnectorState {}

class ClauseConnectorLoading extends ClauseConnectorState {}

class ClauseConnectorLoaded extends ClauseConnectorState {
  final List<ClauseConnectorQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const ClauseConnectorLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  ClauseConnectorQuest get currentQuest => quests[currentIndex];

  ClauseConnectorLoaded copyWith({
    List<ClauseConnectorQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return ClauseConnectorLoaded(
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

class ClauseConnectorGameComplete extends ClauseConnectorState {
  final int xpEarned;
  final int coinsEarned;

  const ClauseConnectorGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class ClauseConnectorGameOver extends ClauseConnectorState {}

class ClauseConnectorError extends ClauseConnectorState {
  final String message;

  const ClauseConnectorError(this.message);

  @override
  List<Object?> get props => [message];
}
