import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/grammar/parts_of_speech/domain/entities/parts_of_speech_quest.dart';

abstract class PartsOfSpeechState extends Equatable {
  const PartsOfSpeechState();

  @override
  List<Object?> get props => [];
}

class PartsOfSpeechInitial extends PartsOfSpeechState {}

class PartsOfSpeechLoading extends PartsOfSpeechState {}

class PartsOfSpeechLoaded extends PartsOfSpeechState {
  final List<PartsOfSpeechQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const PartsOfSpeechLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  PartsOfSpeechQuest get currentQuest => quests[currentIndex];

  PartsOfSpeechLoaded copyWith({
    List<PartsOfSpeechQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return PartsOfSpeechLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      hintUsed: hintUsed ?? this.hintUsed,
    );
  }

  @override
  List<Object?> get props => [quests, currentIndex, livesRemaining, lastAnswerCorrect, hintUsed];
}

class PartsOfSpeechGameComplete extends PartsOfSpeechState {
  final int xpEarned;
  final int coinsEarned;

  const PartsOfSpeechGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class PartsOfSpeechGameOver extends PartsOfSpeechState {}

class PartsOfSpeechError extends PartsOfSpeechState {
  final String message;

  const PartsOfSpeechError(this.message);

  @override
  List<Object?> get props => [message];
}
