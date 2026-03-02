import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/speaking/scene_description_speaking/domain/entities/scene_description_speaking_quest.dart';

abstract class SceneDescriptionSpeakingState extends Equatable {
  const SceneDescriptionSpeakingState();

  @override
  List<Object?> get props => [];
}

class SceneDescriptionSpeakingInitial extends SceneDescriptionSpeakingState {}

class SceneDescriptionSpeakingLoading extends SceneDescriptionSpeakingState {}

class SceneDescriptionSpeakingLoaded extends SceneDescriptionSpeakingState {
  final List<SceneDescriptionSpeakingQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const SceneDescriptionSpeakingLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  SceneDescriptionSpeakingQuest get currentQuest => quests[currentIndex];

  SceneDescriptionSpeakingLoaded copyWith({
    List<SceneDescriptionSpeakingQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return SceneDescriptionSpeakingLoaded(
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

class SceneDescriptionSpeakingGameComplete
    extends SceneDescriptionSpeakingState {
  final int xpEarned;
  final int coinsEarned;

  const SceneDescriptionSpeakingGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class SceneDescriptionSpeakingGameOver extends SceneDescriptionSpeakingState {}

class SceneDescriptionSpeakingError extends SceneDescriptionSpeakingState {
  final String message;

  const SceneDescriptionSpeakingError(this.message);

  @override
  List<Object?> get props => [message];
}
