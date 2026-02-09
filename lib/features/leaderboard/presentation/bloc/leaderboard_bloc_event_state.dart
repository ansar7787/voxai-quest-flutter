import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';

// Events
abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();
  @override
  List<Object> get props => [];
}

class LoadLeaderboard extends LeaderboardEvent {}

// States
abstract class LeaderboardState extends Equatable {
  const LeaderboardState();
  @override
  List<Object> get props => [];
}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<UserEntity> users;
  const LeaderboardLoaded(this.users);
  @override
  List<Object> get props => [users];
}

class LeaderboardError extends LeaderboardState {
  final String message;
  const LeaderboardError(this.message);
  @override
  List<Object> get props => [message];
}
