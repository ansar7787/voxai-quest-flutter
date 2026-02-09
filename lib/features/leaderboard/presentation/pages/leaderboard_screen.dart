import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/leaderboard/presentation/bloc/leaderboard_bloc.dart';
import 'package:voxai_quest/features/leaderboard/presentation/bloc/leaderboard_bloc_event_state.dart';
import 'package:voxai_quest/core/presentation/widgets/shimmer_loading.dart';
import 'package:voxai_quest/core/utils/injection_container.dart' as di;

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<LeaderboardBloc>()..add(LoadLeaderboard()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Leaderboard')),
        body: BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (context, state) {
            if (state is LeaderboardLoading) {
              return const Center(
                child: ShimmerLoading.rectangular(
                  width: double.infinity,
                  height: 60,
                ),
              );
            } else if (state is LeaderboardLoaded) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getRankColor(index),
                      child: Text(
                        '#${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(user.displayName ?? 'Unknown User'),
                    subtitle: Text('Level ${user.level}'),
                    trailing: Text(
                      '${user.coins} 🪙',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  );
                },
              );
            } else if (state is LeaderboardError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Color _getRankColor(int index) {
    if (index == 0) return Colors.amber; // Gold
    if (index == 1) return Colors.grey; // Silver
    if (index == 2) return Colors.brown; // Bronze
    return Colors.blueGrey;
  }
}
