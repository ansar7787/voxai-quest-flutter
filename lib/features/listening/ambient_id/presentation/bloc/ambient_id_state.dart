import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/listening/ambient_id/domain/entities/ambient_id_quest.dart';

abstract class AmbientIdState extends Equatable {
  const AmbientIdState();

  @override
  List<Object?> get props => [];
}

class AmbientIdInitial extends AmbientIdState {}

class AmbientIdLoading extends AmbientIdState {}

class AmbientIdLoaded extends AmbientIdState {
  final List<AmbientIdQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const AmbientIdLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  AmbientIdQuest get currentQuest => quests[currentIndex];

  AmbientIdLoaded copyWith({
    List<AmbientIdQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return AmbientIdLoaded(
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

class AmbientIdGameComplete extends AmbientIdState {
  final int xpEarned;
  final int coinsEarned;

  const AmbientIdGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class AmbientIdGameOver extends AmbientIdState {}

class AmbientIdError extends AmbientIdState {
  final String message;

  const AmbientIdError(this.message);

  @override
  List<Object?> get props => [message];
}
