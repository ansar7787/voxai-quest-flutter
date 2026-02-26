import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/presentation/widgets/glass_tile.dart';
import 'package:voxai_quest/core/presentation/widgets/mesh_gradient_background.dart';
import 'package:voxai_quest/core/presentation/widgets/shimmer_image.dart';
import 'package:voxai_quest/core/presentation/widgets/shimmer_loading.dart';
import 'package:voxai_quest/core/utils/injection_container.dart' as di;
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voxai_quest/features/leaderboard/presentation/bloc/leaderboard_bloc.dart';
import 'package:voxai_quest/features/leaderboard/presentation/bloc/leaderboard_bloc_event_state.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (_) => di.sl<LeaderboardBloc>()..add(LoadLeaderboard()),
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC),
        body: BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (context, state) {
            return Stack(
              children: [
                const MeshGradientBackground(showLetters: true),
                if (state is LeaderboardLoaded)
                  RefreshIndicator(
                    onRefresh: () async {
                      context.read<LeaderboardBloc>().add(LoadLeaderboard());
                      // Wait for a short duration to ensure the indicator shows nicely
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    backgroundColor: Colors.transparent,
                    color: const Color(0xFF2563EB),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollEndNotification &&
                            notification.metrics.extentAfter == 0) {
                          // Trigger real-time update when user reaches bottom
                          context.read<LeaderboardBloc>().add(
                            LoadLeaderboard(),
                          );
                        }
                        return false;
                      },
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        slivers: [
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 100),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: _buildNexusPortal(
                                context,
                                state.users.take(3).toList(),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 24.h,
                              ),
                              child: _buildTopRankCard(context, state.users),
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final user = state.users[index + 3];
                                  final rank = index + 4;
                                  final currentUser = context
                                      .read<AuthBloc>()
                                      .state
                                      .user;
                                  final isMe = currentUser?.id == user.id;

                                  // Distance to someone above
                                  final distanceToNext =
                                      state.users[index + 2].totalExp -
                                      user.totalExp;

                                  return _buildNexusBlade(
                                        context,
                                        user,
                                        rank,
                                        isMe,
                                        distanceToNext: distanceToNext,
                                      )
                                      .animate(delay: (100 * index).ms)
                                      .fadeIn(duration: 400.ms)
                                      .slideX(begin: 0.1, end: 0);
                                },
                                childCount: state.users.length > 3
                                    ? (state.users.length > 10
                                          ? 7
                                          : state.users.length - 3)
                                    : 0,
                              ),
                            ),
                          ),
                          if (state.users.length > 10)
                            SliverPadding(
                              padding: EdgeInsets.symmetric(vertical: 24.h),
                              sliver: SliverToBoxAdapter(
                                child: Center(
                                  child: Text(
                                    'INITIATES IN FILTRATION',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w900,
                                      color: isDark
                                          ? Colors.white24
                                          : Colors.black12,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (state.users.length > 10)
                            SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  final user = state.users[index + 10];
                                  final rank = index + 11;
                                  final currentUser = context
                                      .read<AuthBloc>()
                                      .state
                                      .user;
                                  final isMe = currentUser?.id == user.id;

                                  return _buildNexusBlade(
                                        context,
                                        user,
                                        rank,
                                        isMe,
                                      )
                                      .animate(delay: (50 * index).ms)
                                      .fadeIn(duration: 300.ms);
                                }, childCount: state.users.length - 10),
                              ),
                            ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 120),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state is LeaderboardLoading)
                  const LeaderboardShimmerLoading()
                else if (state is LeaderboardError)
                  Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNexusPortal(BuildContext context, List<UserEntity> top3) {
    if (top3.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 380.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Pulse Engine (Nexus Core)
          Positioned(
            top: 60.h,
            child:
                Container(
                      width: 280.w,
                      height: 280.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF2563EB).withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.2, 1.2),
                      duration: 4.seconds,
                      curve: Curves.easeInOut,
                    ),
          ),

          // Energy Arcs (Visual only for now)
          // Simplified Energy Arcs using layered thin circles
          ...List.generate(
            3,
            (index) => Positioned(
              top: 70.h + (index * 20),
              child:
                  Container(
                        width: 240.w - (index * 40),
                        height: 240.w - (index * 40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(
                              0xFF2563EB,
                            ).withValues(alpha: 0.05),
                            width: 1,
                          ),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat())
                      .rotate(duration: (10 + index * 5).seconds),
            ),
          ),

          // RANK 2 (SILVER) - Left
          if (top3.length > 1)
            Positioned(
              left: 10.w,
              top: 100.h,
              child: _buildNexusChamber(
                context,
                top3[1],
                2,
                const Color(0xFFC0C0C0),
              ),
            ),
          // RANK 3 (BRONZE) - Right
          if (top3.length > 2)
            Positioned(
              right: 10.w,
              top: 100.h,
              child: _buildNexusChamber(
                context,
                top3[2],
                3,
                const Color(0xFFCD7F32),
              ),
            ),
          // RANK 1 (GOLD) - Center Front
          Positioned(
            top: 40.h,
            child: _buildNexusChamber(
              context,
              top3[0],
              1,
              const Color(0xFFFFD700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNexusChamber(
    BuildContext context,
    UserEntity user,
    int rank,
    Color accentColor,
  ) {
    final isFirst = rank == 1;
    final avatarSize = (isFirst ? 110 : 80).r;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pulsing Energy Ring
        SizedBox(
          width: avatarSize + 20,
          height: avatarSize + 20,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                    width: avatarSize + 15,
                    height: avatarSize + 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat())
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                    duration: 2.seconds,
                    curve: Curves.easeInOut,
                  )
                  .fadeOut(),

              // The Operative
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.8),
                    width: isFirst ? 4 : 2,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.r),
                  child: ClipOval(
                    child: ShimmerImage(
                      imageUrl: user.photoUrl ?? '',
                      width: avatarSize - 10,
                      height: avatarSize - 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        // Nexus Badge (Rank + Level)
        GlassTile(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          borderRadius: BorderRadius.circular(20.r),
          borderColor: accentColor.withValues(alpha: 0.4),
          color: Colors.black.withValues(alpha: 0.3),
          borderWidth: 1,
          child: Column(
            children: [
              Text(
                'GRANDMASTER #0$rank',
                style: GoogleFonts.outfit(
                  fontSize: isFirst ? 9.sp : 7.sp,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                  letterSpacing: 2,
                ),
              ),
              Text(
                (user.displayName ?? 'Operative').toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: isFirst ? 14.sp : 11.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              _buildNexusStatPod(user, accentColor),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildNexusStatPod(UserEntity user, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        'LVL ${user.level}',
        style: GoogleFonts.outfit(
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildNexusBlade(
    BuildContext context,
    UserEntity user,
    int rank,
    bool isMe, {
    int? distanceToNext,
  }) {
    // final isDark = Theme.of(context).brightness == Brightness.dark; // Unused

    // Neural Nexus Tiers
    final isVanguard = rank <= 10;
    final isOperative = rank <= 50;

    final Color tierColor = isVanguard
        ? const Color(0xFF3B82F6) // Vanguard Blue
        : isOperative
        ? const Color(0xFF22D3EE) // Operative Cyan
        : const Color(0xFF94A3B8); // Initiate Slate

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: Stack(
        children: [
          // Holographic Blade Body
          GlassTile(
            padding: EdgeInsets.all(12.r),
            borderRadius: BorderRadius.circular(16.r),
            borderColor: tierColor.withValues(alpha: isMe ? 0.8 : 0.25),
            color: isMe
                ? tierColor.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.1),
            borderWidth: isMe ? 2 : 1,
            child: Row(
              children: [
                // Rank Hexagon Badge
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: tierColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: tierColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        color: tierColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                // Avatar with Circular Scanner
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: tierColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: ClipOval(
                        child: ShimmerImage(
                          imageUrl: user.photoUrl ?? '',
                          width: 44.r,
                          height: 44.r,
                        ),
                      ),
                    ),
                    // Scanning Ring (Only for top tiers)
                    if (isVanguard)
                      Container(
                            width: 50.r,
                            height: 50.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: tierColor.withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                            ),
                          )
                          .animate(onPlay: (c) => c.repeat())
                          .rotate(duration: 3.seconds),
                  ],
                ),
                SizedBox(width: 14.w),
                // Data Stream (Name + Tier)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            (user.displayName ?? 'Operative').toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (isMe)
                            Padding(
                              padding: EdgeInsets.only(left: 6.w),
                              child: Icon(
                                Icons.verified_user_rounded,
                                size: 12.r,
                                color: tierColor,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        isVanguard
                            ? 'VANGUARD ELITE'
                            : (isOperative
                                  ? 'FIELD OPERATIVE'
                                  : 'INITIATE UNIT'),
                        style: GoogleFonts.outfit(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w900,
                          color: tierColor.withValues(alpha: 0.7),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Momentum Data
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${user.totalExp} XP',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    if (distanceToNext != null && distanceToNext > 0)
                      Text(
                        '-$distanceToNext XP',
                        style: GoogleFonts.outfit(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.redAccent.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Scan-line Animation
          Positioned.fill(
            child:
                ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              tierColor.withValues(alpha: 0.05),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .slideY(
                      begin: -1,
                      end: 2,
                      duration: 3.seconds,
                      curve: Curves.linear,
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRankCard(BuildContext context, List<UserEntity> allUsers) {
    final currentUser = context.read<AuthBloc>().state.user;
    if (currentUser == null) return const SizedBox.shrink();

    final rank = allUsers.indexWhere((u) => u.id == currentUser.id) + 1;
    if (rank == 0) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.15),
            blurRadius: 40,
            spreadRadius: -10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: GlassTile(
        padding: EdgeInsets.all(16.r),
        borderRadius: BorderRadius.circular(40.r),
        borderColor: const Color(0xFF2563EB).withValues(alpha: 0.8),
        color: const Color(0xFF2563EB).withValues(alpha: 0.25),
        borderWidth: 2,
        child: Row(
          children: [
            // Rank Capsule with Neon Glow
            Container(
              width: 54.w,
              height: 54.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            // Avatar with Premium Glow
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipOval(
                child: ShimmerImage(
                  imageUrl: currentUser.photoUrl ?? '',
                  width: 44.r,
                  height: 44.r,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'YOUR PERFORMANCE',
                    style: GoogleFonts.outfit(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white70,
                      letterSpacing: 2.5,
                    ),
                  ),
                  Text(
                    currentUser.displayName?.toUpperCase() ?? 'OPERATIVE',
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Level Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Text(
                'LVL ${currentUser.level}',
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }
}
