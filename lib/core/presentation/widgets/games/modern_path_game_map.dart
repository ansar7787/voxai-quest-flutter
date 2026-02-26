import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:voxai_quest/core/utils/ad_service.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/core/presentation/widgets/games/voxai_letter_background.dart';
import 'package:voxai_quest/core/presentation/widgets/games/modern_path_painter.dart';
import 'package:voxai_quest/core/presentation/themes/level_theme_helper.dart';
import 'package:voxai_quest/core/utils/injection_container.dart' as di;

class ModernPathGameMap extends StatelessWidget {
  final String gameType;
  final String categoryId;
  final int totalLevels;

  const ModernPathGameMap({
    super.key,
    required this.gameType,
    required this.categoryId,
    this.totalLevels = 200,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = LevelThemeHelper.getTheme(gameType);
    final authState = context.watch<AuthBloc>().state;

    // Fallback logic for unlocked levels
    final int unlockedLevels = authState.user?.unlockedLevels[gameType] ?? 1;

    final List<Offset> points = [];
    for (int i = 0; i < totalLevels; i++) {
      final levelNumber = i + 1;
      // Generate a curvy layout similar to the image
      // Alternating left/right snake pattern
      final horizontalOffset = (math.sin(levelNumber * 1.5) * 80.w);
      final verticalPosition = 120.h + (i * 140.h);
      points.add(
        Offset(
          ScreenUtil().screenWidth / 2 + horizontalOffset,
          verticalPosition,
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, theme, isDark),
      body: Stack(
        children: [
          // Dynamic Background Layer
          _buildBackground(theme),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              children: [
                // The Curvy Path
                CustomPaint(
                  size: Size(
                    ScreenUtil().screenWidth,
                    120.h + (totalLevels * 140.h) + 100.h,
                  ),
                  painter: ModernPathPainter(
                    points: points,
                    color: theme.primaryColor.withValues(alpha: 0.2),
                    thickness: 8.w,
                  ),
                ),

                // Interaction Nodes
                Column(
                  children: [
                    SizedBox(height: 120.h),
                    ...List.generate(totalLevels, (index) {
                      final levelNumber = index + 1;
                      final isUnlocked = levelNumber <= unlockedLevels;
                      final isCurrent = levelNumber == unlockedLevels;
                      final horizontalOffset =
                          (math.sin(levelNumber * 1.5) * 80.w);

                      return Center(
                        child: Transform.translate(
                          offset: Offset(horizontalOffset, 0),
                          child: _buildPathNode(
                            context,
                            levelNumber,
                            isUnlocked,
                            isCurrent,
                            isDark,
                            theme,
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 150.h),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeResult theme,
    bool isDark,
  ) {
    return AppBar(
      title: Text(
        theme.title,
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w900,
          fontSize: 14.sp,
          letterSpacing: 4,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.chevron_left_rounded, size: 28.r),
        onPressed: () => context.pop(),
        color: isDark ? Colors.white70 : Colors.black54,
      ),
    );
  }

  Widget _buildBackground(ThemeResult theme) {
    return Stack(
      children: [
        // Custom letter background for texture
        VoxaiLetterBackground(
          color: theme.primaryColor.withValues(alpha: 0.1),
          style: VoxaiBackgroundStyle.scatter,
        ),
        // Subtle gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.primaryColor.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPathNode(
    BuildContext context,
    int level,
    bool isUnlocked,
    bool isCurrent,
    bool isDark,
    ThemeResult theme,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // "Today's Topic" Tooltip for current level
          if (isCurrent)
            Positioned(top: -85.h, child: _buildTopicTooltip(theme, isDark)),

          // Pulse animation for current level
          if (isCurrent)
            Container(
                  width: 130.r,
                  height: 130.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.primaryColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                )
                .animate(onPlay: (c) => c.repeat())
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.2, 1.2),
                  duration: 2.seconds,
                )
                .fadeOut(),

          // The Glass Node
          ScaleButton(
            onTap: () async {
              if (!isUnlocked) {
                _showLockedFeedback(context, theme.primaryColor);
                return;
              }
              final authState = context.read<AuthBloc>().state;
              di.sl<AdService>().showInterstitialAd(
                onDismissed: () {
                  if (context.mounted) {
                    context.push(
                      '/game?category=$categoryId&gameType=$gameType&level=$level',
                    );
                  }
                },
                isPremium: authState.user?.isPremium ?? false,
              );
            },
            child: Container(
              width: isCurrent ? 100.r : 80.r,
              height: isCurrent ? 100.r : 80.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked
                    ? (isCurrent
                          ? theme.primaryColor
                          : theme.primaryColor.withValues(alpha: 0.15))
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.03)),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: theme.primaryColor.withValues(alpha: 0.5),
                          blurRadius: 25,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
                border: Border.all(
                  color: isCurrent
                      ? Colors.white
                      : (isUnlocked
                            ? theme.primaryColor.withValues(alpha: 0.3)
                            : Colors.transparent),
                  width: isCurrent ? 4 : 2,
                ),
              ),
              child: Center(
                child: isUnlocked
                    ? (isCurrent
                          ? Icon(theme.icon, color: Colors.white, size: 38.r)
                          : Text(
                              "$level",
                              style: GoogleFonts.outfit(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w900,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ))
                    : Icon(
                        Icons.lock_outline_rounded,
                        color: isDark ? Colors.white24 : Colors.black12,
                        size: 24.r,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicTooltip(ThemeResult theme, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "TODAY'S TOPIC",
            style: GoogleFonts.outfit(
              fontSize: 10.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            theme.title,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ).animate().move(
      begin: const Offset(0, 5),
      end: const Offset(0, 0),
      duration: 600.ms,
      curve: Curves.easeOutBack,
    );
  }

  void _showLockedFeedback(BuildContext context, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'QUEST LOCKED! COMPLETE PREVIOUS LEVELS.',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            fontSize: 12.sp,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        margin: EdgeInsets.all(20.r),
      ),
    );
  }
}
