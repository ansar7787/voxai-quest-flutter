import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/listening/emotion_recognition/domain/entities/emotion_recognition_quest.dart';

abstract class EmotionRecognitionState extends Equatable {
  const EmotionRecognitionState();

  @override
  List<Object?> get props => [];
}

class EmotionRecognitionInitial extends EmotionRecognitionState {}

class EmotionRecognitionLoading extends EmotionRecognitionState {}

class EmotionRecognitionLoaded extends EmotionRecognitionState {
  final List<EmotionRecognitionQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const EmotionRecognitionLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  EmotionRecognitionQuest get currentQuest => quests[currentIndex];

  EmotionRecognitionLoaded copyWith({
    List<EmotionRecognitionQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return EmotionRecognitionLoaded(
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

class EmotionRecognitionGameComplete extends EmotionRecognitionState {
  final int xpEarned;
  final int coinsEarned;

  const EmotionRecognitionGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class EmotionRecognitionGameOver extends EmotionRecognitionState {}

class EmotionRecognitionError extends EmotionRecognitionState {
  final String message;

  const EmotionRecognitionError(this.message);

  @override
  List<Object?> get props => [message];
}
