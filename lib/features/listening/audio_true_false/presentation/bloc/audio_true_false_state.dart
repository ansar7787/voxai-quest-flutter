import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/listening/audio_true_false/domain/entities/audio_true_false_quest.dart';

abstract class AudioTrueFalseState extends Equatable {
  const AudioTrueFalseState();

  @override
  List<Object?> get props => [];
}

class AudioTrueFalseInitial extends AudioTrueFalseState {}

class AudioTrueFalseLoading extends AudioTrueFalseState {}

class AudioTrueFalseLoaded extends AudioTrueFalseState {
  final List<AudioTrueFalseQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const AudioTrueFalseLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  AudioTrueFalseQuest get currentQuest => quests[currentIndex];

  AudioTrueFalseLoaded copyWith({
    List<AudioTrueFalseQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return AudioTrueFalseLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
    );
  }

  @override
  List<Object?> get props => [quests, currentIndex, livesRemaining, lastAnswerCorrect];
}

class AudioTrueFalseGameComplete extends AudioTrueFalseState {
  final int xpEarned;
  final int coinsEarned;

  const AudioTrueFalseGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class AudioTrueFalseGameOver extends AudioTrueFalseState {}

class AudioTrueFalseError extends AudioTrueFalseState {
  final String message;

  const AudioTrueFalseError(this.message);

  @override
  List<Object?> get props => [message];
}
