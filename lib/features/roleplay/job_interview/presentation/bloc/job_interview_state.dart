import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/roleplay/job_interview/domain/entities/job_interview_quest.dart';

abstract class JobInterviewState extends Equatable {
  const JobInterviewState();

  @override
  List<Object?> get props => [];
}

class JobInterviewInitial extends JobInterviewState {}

class JobInterviewLoading extends JobInterviewState {}

class JobInterviewLoaded extends JobInterviewState {
  final List<JobInterviewQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final int xpEarned;
  final int coinsEarned;

  const JobInterviewLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.xpEarned = 0,
    this.coinsEarned = 0,
  });

  JobInterviewQuest get currentQuest => quests[currentIndex];

  JobInterviewLoaded copyWith({
    List<JobInterviewQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    int? xpEarned,
    int? coinsEarned,
  }) {
    return JobInterviewLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      xpEarned: xpEarned ?? this.xpEarned,
      coinsEarned: coinsEarned ?? this.coinsEarned,
    );
  }

  @override
  List<Object?> get props => [
    quests,
    currentIndex,
    livesRemaining,
    lastAnswerCorrect,
    xpEarned,
    coinsEarned,
  ];
}

class JobInterviewError extends JobInterviewState {
  final String message;
  const JobInterviewError(this.message);

  @override
  List<Object?> get props => [message];
}

class JobInterviewGameComplete extends JobInterviewState {
  final int xpEarned;
  final int coinsEarned;
  const JobInterviewGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class JobInterviewGameOver extends JobInterviewState {}
