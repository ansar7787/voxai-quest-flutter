import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/listening/audio_fill_blanks/domain/entities/audio_fill_blanks_quest.dart';

abstract class AudioFillBlanksState extends Equatable {
  const AudioFillBlanksState();

  @override
  List<Object?> get props => [];
}

class AudioFillBlanksInitial extends AudioFillBlanksState {}

class AudioFillBlanksLoading extends AudioFillBlanksState {}

class AudioFillBlanksLoaded extends AudioFillBlanksState {
  final List<AudioFillBlanksQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const AudioFillBlanksLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  AudioFillBlanksQuest get currentQuest => quests[currentIndex];

  AudioFillBlanksLoaded copyWith({
    List<AudioFillBlanksQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return AudioFillBlanksLoaded(
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

class AudioFillBlanksGameComplete extends AudioFillBlanksState {
  final int xpEarned;
  final int coinsEarned;

  const AudioFillBlanksGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class AudioFillBlanksGameOver extends AudioFillBlanksState {}

class AudioFillBlanksError extends AudioFillBlanksState {
  final String message;

  const AudioFillBlanksError(this.message);

  @override
  List<Object?> get props => [message];
}
