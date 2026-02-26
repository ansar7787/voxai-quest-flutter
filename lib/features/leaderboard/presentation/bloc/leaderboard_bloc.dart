import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';
import 'package:voxai_quest/features/leaderboard/domain/repositories/leaderboard_repository.dart';
import 'package:voxai_quest/features/leaderboard/presentation/bloc/leaderboard_bloc_event_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final LeaderboardRepository repository;

  LeaderboardBloc({required this.repository}) : super(LeaderboardInitial()) {
    on<LoadLeaderboard>(_onLoadLeaderboard);
  }

  Future<void> _onLoadLeaderboard(
    LoadLeaderboard event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(LeaderboardLoading());
    final result = await repository.getTopUsers();
    result.fold((failure) => emit(LeaderboardError(failure.message)), (users) {
      // Sort: Level (desc) -> totalExp (desc) -> coins (desc)
      final sortedUsers = List<UserEntity>.from(users)
        ..sort((a, b) {
          if (b.level != a.level) {
            return b.level.compareTo(a.level);
          }
          if (b.totalExp != a.totalExp) return b.totalExp.compareTo(a.totalExp);
          return b.coins.compareTo(a.coins);
        });
      emit(LeaderboardLoaded(sortedUsers));
    });
  }
}
