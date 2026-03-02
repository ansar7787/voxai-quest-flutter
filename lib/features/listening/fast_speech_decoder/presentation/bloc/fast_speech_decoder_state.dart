import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/listening/fast_speech_decoder/domain/entities/fast_speech_decoder_quest.dart';

abstract class FastSpeechDecoderState extends Equatable {
  const FastSpeechDecoderState();

  @override
  List<Object?> get props => [];
}

class FastSpeechDecoderInitial extends FastSpeechDecoderState {}

class FastSpeechDecoderLoading extends FastSpeechDecoderState {}

class FastSpeechDecoderLoaded extends FastSpeechDecoderState {
  final List<FastSpeechDecoderQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const FastSpeechDecoderLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  FastSpeechDecoderQuest get currentQuest => quests[currentIndex];

  FastSpeechDecoderLoaded copyWith({
    List<FastSpeechDecoderQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return FastSpeechDecoderLoaded(
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

class FastSpeechDecoderGameComplete extends FastSpeechDecoderState {
  final int xpEarned;
  final int coinsEarned;

  const FastSpeechDecoderGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class FastSpeechDecoderGameOver extends FastSpeechDecoderState {}

class FastSpeechDecoderError extends FastSpeechDecoderState {
  final String message;

  const FastSpeechDecoderError(this.message);

  @override
  List<Object?> get props => [message];
}
