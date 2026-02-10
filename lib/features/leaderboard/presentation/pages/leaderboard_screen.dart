import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voxai_quest/features/leaderboard/presentation/bloc/leaderboard_bloc.dart';
import 'package:voxai_quest/features/leaderboard/presentation/bloc/leaderboard_bloc_event_state.dart';
import 'package:voxai_quest/core/utils/injection_container.dart' as di;

import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<LeaderboardBloc>()..add(LoadLeaderboard()),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.indigo.shade900, Colors.black],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
                    builder: (context, state) {
                      if (state is LeaderboardLoading) {
                        return Center(
                          child: CircularProgressIndicator(color: Colors.amber),
                        );
                      } else if (state is LeaderboardLoaded) {
                        return _buildLeaderboardContent(context, state.users);
                      } else if (state is LeaderboardError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          Text(
            'Global Rankings',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 48.w), // Balance back button
        ],
      ),
    );
  }

  Widget _buildLeaderboardContent(
    BuildContext context,
    List<UserEntity> users,
  ) {
    if (users.isEmpty) {
      return Center(
        child: Text('No players yet!', style: TextStyle(color: Colors.white)),
      );
    }

    final top3 = users.take(3).toList();
    final rest = users.skip(3).toList();
    final currentUser = context.read<AuthBloc>().state.user;

    return Column(
      children: [
        SizedBox(height: 20.h),
        _buildPodium(top3),
        SizedBox(height: 20.h),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: rest.length,
              itemBuilder: (context, index) {
                final user = rest[index];
                final rank = index + 4;
                final isMe = currentUser?.id == user.id;

                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.blue.withValues(alpha: 0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16.r),
                    border: isMe ? Border.all(color: Colors.blue) : null,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '#$rank',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      CircleAvatar(
                        radius: 20.r,
                        backgroundImage: user.photoUrl != null
                            ? NetworkImage(user.photoUrl!)
                            : null,
                        child: user.photoUrl == null
                            ? Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName ?? 'Player',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Level ${user.level}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${user.coins}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[800],
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPodium(List<UserEntity> top3) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (top3.length > 1) _buildPodiumPlace(top3[1], 2),
        if (top3.isNotEmpty) _buildPodiumPlace(top3[0], 1),
        if (top3.length > 2) _buildPodiumPlace(top3[2], 3),
      ],
    );
  }

  Widget _buildPodiumPlace(UserEntity user, int rank) {
    final isFirst = rank == 1;
    final size = isFirst ? 100.r : 80.r;
    final height = isFirst ? 40.h : 20.h;
    final color = rank == 1
        ? Colors.amber
        : (rank == 2 ? Colors.grey[300] : Colors.brown[300]);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          CircleAvatar(
            radius: size / 2,
            backgroundImage: user.photoUrl != null
                ? NetworkImage(user.photoUrl!)
                : null,
            backgroundColor: color,
            child: user.photoUrl == null
                ? Icon(Icons.person, size: 30.r, color: Colors.white)
                : null,
          ),
          SizedBox(height: 8.h),
          Text(
            user.displayName?.split(' ').first ?? 'Player',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            '${user.coins}',
            style: TextStyle(color: Colors.amber, fontSize: 12.sp),
          ),
          SizedBox(height: 8.h),
          Container(
            width: size,
            height: height + 60.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
