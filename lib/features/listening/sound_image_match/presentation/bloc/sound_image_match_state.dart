import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/listening/sound_image_match/domain/entities/sound_image_match_quest.dart';

abstract class SoundImageMatchState extends Equatable {
  const SoundImageMatchState();

  @override
  List<Object?> get props => [];
}

class SoundImageMatchInitial extends SoundImageMatchState {}

class SoundImageMatchLoading extends SoundImageMatchState {}

class SoundImageMatchLoaded extends SoundImageMatchState {
  final List<SoundImageMatchQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const SoundImageMatchLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  SoundImageMatchQuest get currentQuest => quests[currentIndex];

  SoundImageMatchLoaded copyWith({
    List<SoundImageMatchQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return SoundImageMatchLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
    );
  }

  @override
  List<Object?> get props => [quests, currentIndex, livesRemaining, lastAnswerCorrect];
}

class SoundImageMatchGameComplete extends SoundImageMatchState {
  final int xpEarned;
  final int coinsEarned;

  const SoundImageMatchGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class SoundImageMatchGameOver extends SoundImageMatchState {}

class SoundImageMatchError extends SoundImageMatchState {
  final String message;

  const SoundImageMatchError(this.message);

  @override
  List<Object?> get props => [message];
}
