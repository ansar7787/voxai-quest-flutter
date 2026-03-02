import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/roleplay/gourmet_order/domain/entities/gourmet_order_quest.dart';

abstract class GourmetOrderState extends Equatable {
  const GourmetOrderState();

  @override
  List<Object?> get props => [];
}

class GourmetOrderInitial extends GourmetOrderState {}

class GourmetOrderLoading extends GourmetOrderState {}

class GourmetOrderLoaded extends GourmetOrderState {
  final List<GourmetOrderQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final int xpEarned;
  final int coinsEarned;

  const GourmetOrderLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.xpEarned = 0,
    this.coinsEarned = 0,
  });

  GourmetOrderQuest get currentQuest => quests[currentIndex];

  GourmetOrderLoaded copyWith({
    List<GourmetOrderQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    int? xpEarned,
    int? coinsEarned,
  }) {
    return GourmetOrderLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      xpEarned: xpEarned ?? this.xpEarned,
      coinsEarned: coinsEarned ?? this.coinsEarned,
    );
  }

  @override
  List<Object?> get props => [
        quests,
        currentIndex,
        livesRemaining,
        lastAnswerCorrect,
        xpEarned,
        coinsEarned,
      ];
}

class GourmetOrderError extends GourmetOrderState {
  final String message;
  const GourmetOrderError(this.message);

  @override
  List<Object?> get props => [message];
}

class GourmetOrderGameComplete extends GourmetOrderState {
  final int xpEarned;
  final int coinsEarned;
  const GourmetOrderGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class GourmetOrderGameOver extends GourmetOrderState {}
