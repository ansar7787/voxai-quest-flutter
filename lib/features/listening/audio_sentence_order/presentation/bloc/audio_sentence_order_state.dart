import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/listening/audio_sentence_order/domain/entities/audio_sentence_order_quest.dart';

abstract class AudioSentenceOrderState extends Equatable {
  const AudioSentenceOrderState();

  @override
  List<Object?> get props => [];
}

class AudioSentenceOrderInitial extends AudioSentenceOrderState {}

class AudioSentenceOrderLoading extends AudioSentenceOrderState {}

class AudioSentenceOrderLoaded extends AudioSentenceOrderState {
  final List<AudioSentenceOrderQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const AudioSentenceOrderLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  AudioSentenceOrderQuest get currentQuest => quests[currentIndex];

  AudioSentenceOrderLoaded copyWith({
    List<AudioSentenceOrderQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return AudioSentenceOrderLoaded(
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

class AudioSentenceOrderGameComplete extends AudioSentenceOrderState {
  final int xpEarned;
  final int coinsEarned;

  const AudioSentenceOrderGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class AudioSentenceOrderGameOver extends AudioSentenceOrderState {}

class AudioSentenceOrderError extends AudioSentenceOrderState {
  final String message;

  const AudioSentenceOrderError(this.message);

  @override
  List<Object?> get props => [message];
}
