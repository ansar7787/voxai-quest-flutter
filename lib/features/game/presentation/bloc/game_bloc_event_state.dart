import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/game/domain/entities/game_quest.dart';

abstract class GameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartGame extends GameEvent {}

class SubmitAnswer extends GameEvent {
  final dynamic answer;
  SubmitAnswer(this.answer);

  @override
  List<Object?> get props => [answer];
}

class NextQuest extends GameEvent {}

class LoadDailyQuest extends GameEvent {}

class StartTimeAttack extends GameEvent {}

class EndTimeAttack extends GameEvent {} // New

abstract class GameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

enum SubmissionStatus { none, correct, incorrect }

class GameInProgress extends GameState {
  final GameQuest currentQuest;
  final int level;
  final int score;
  final SubmissionStatus status;

  final int lives;

  final bool isTimeAttack;
  final DateTime? endTime;

  GameInProgress({
    required this.currentQuest,
    required this.level,
    required this.score,
    required this.lives,
    this.status = SubmissionStatus.none,
    this.isTimeAttack = false,
    this.endTime,
  });

  @override
  List<Object?> get props => [
    currentQuest,
    level,
    score,
    lives,
    status,
    isTimeAttack,
    endTime,
  ];

  GameInProgress copyWith({
    GameQuest? currentQuest,
    int? level,
    int? score,
    int? lives,
    SubmissionStatus? status,
    bool? isTimeAttack,
    DateTime? endTime,
  }) {
    return GameInProgress(
      currentQuest: currentQuest ?? this.currentQuest,
      level: level ?? this.level,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      status: status ?? this.status,
      isTimeAttack: isTimeAttack ?? this.isTimeAttack,
      endTime: endTime ?? this.endTime,
    );
  }
}

class GameFinished extends GameState {
  final int finalScore;
  GameFinished(this.finalScore);

  @override
  List<Object?> get props => [finalScore];
}

class GameSuccess extends GameState {
  final String message;
  final int score;
  final GameQuest nextQuestHelper;
  GameSuccess({
    required this.message,
    required this.score,
    required this.nextQuestHelper,
  });
  @override
  List<Object?> get props => [message, score, nextQuestHelper];
}

class GameFailure extends GameState {
  final String message;
  final int score;
  GameFailure({required this.message, required this.score});
  @override
  List<Object?> get props => [message, score];
}

class GameError extends GameState {
  final String message;
  GameError(this.message);

  @override
  List<Object?> get props => [message];
}
