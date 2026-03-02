import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/grammar/voice_swap/domain/entities/voice_swap_quest.dart';

abstract class VoiceSwapState extends Equatable {
  const VoiceSwapState();

  @override
  List<Object?> get props => [];
}

class VoiceSwapInitial extends VoiceSwapState {}

class VoiceSwapLoading extends VoiceSwapState {}

class VoiceSwapLoaded extends VoiceSwapState {
  final List<VoiceSwapQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const VoiceSwapLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  VoiceSwapQuest get currentQuest => quests[currentIndex];

  VoiceSwapLoaded copyWith({
    List<VoiceSwapQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return VoiceSwapLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      hintUsed: hintUsed ?? this.hintUsed,
    );
  }

  @override
  List<Object?> get props => [
    quests,
    currentIndex,
    livesRemaining,
    lastAnswerCorrect,
    hintUsed,
  ];
}

class VoiceSwapGameComplete extends VoiceSwapState {
  final int xpEarned;
  final int coinsEarned;

  const VoiceSwapGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class VoiceSwapGameOver extends VoiceSwapState {}

class VoiceSwapError extends VoiceSwapState {
  final String message;

  const VoiceSwapError(this.message);

  @override
  List<Object?> get props => [message];
}
