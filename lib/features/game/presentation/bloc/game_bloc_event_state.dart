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

abstract class GameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GameInProgress extends GameState {
  final GameQuest currentQuest;
  final int level;
  final int score;

  GameInProgress({
    required this.currentQuest,
    required this.level,
    required this.score,
  });

  @override
  List<Object?> get props => [currentQuest, level, score];

  GameInProgress copyWith({GameQuest? currentQuest, int? level, int? score}) {
    return GameInProgress(
      currentQuest: currentQuest ?? this.currentQuest,
      level: level ?? this.level,
      score: score ?? this.score,
    );
  }
}

class GameFinished extends GameState {
  final int finalScore;
  GameFinished(this.finalScore);

  @override
  List<Object?> get props => [finalScore];
}

class GameError extends GameState {
  final String message;
  GameError(this.message);

  @override
  List<Object?> get props => [message];
}
