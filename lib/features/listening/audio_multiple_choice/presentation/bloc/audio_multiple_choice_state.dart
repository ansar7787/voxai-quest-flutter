import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/listening/audio_multiple_choice/domain/entities/audio_multiple_choice_quest.dart';

abstract class AudioMultipleChoiceState extends Equatable {
  const AudioMultipleChoiceState();

  @override
  List<Object?> get props => [];
}

class AudioMultipleChoiceInitial extends AudioMultipleChoiceState {}

class AudioMultipleChoiceLoading extends AudioMultipleChoiceState {}

class AudioMultipleChoiceLoaded extends AudioMultipleChoiceState {
  final List<AudioMultipleChoiceQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const AudioMultipleChoiceLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  AudioMultipleChoiceQuest get currentQuest => quests[currentIndex];

  AudioMultipleChoiceLoaded copyWith({
    List<AudioMultipleChoiceQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return AudioMultipleChoiceLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
    );
  }

  @override
  List<Object?> get props => [quests, currentIndex, livesRemaining, lastAnswerCorrect];
}

class AudioMultipleChoiceGameComplete extends AudioMultipleChoiceState {
  final int xpEarned;
  final int coinsEarned;

  const AudioMultipleChoiceGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class AudioMultipleChoiceGameOver extends AudioMultipleChoiceState {}

class AudioMultipleChoiceError extends AudioMultipleChoiceState {
  final String message;

  const AudioMultipleChoiceError(this.message);

  @override
  List<Object?> get props => [message];
}
