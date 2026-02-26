import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:voxai_quest/core/presentation/widgets/mesh_gradient_background.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voxai_quest/features/kids_zone/presentation/utils/kids_assets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/animated_kids_asset.dart';
import 'package:voxai_quest/core/utils/app_router.dart';
import 'package:voxai_quest/core/utils/ad_service.dart';
import 'package:voxai_quest/core/utils/injection_container.dart' as di;
import 'package:voxai_quest/core/presentation/widgets/glass_tile.dart';

class KidsLevelMap extends StatelessWidget {
  final String gameType;
  final String title;
  final Color primaryColor;

  const KidsLevelMap({
    super.key,
    required this.gameType,
    required this.title,
    required this.primaryColor,
  });

  double _getHorizontalOffset(int level, double screenWidth) {
    // Seeded random to keep map consistent across rebuilds
    final random = Random(level * 123);
    // Map width minus node size (90.r) and safe edge padding (50.w * 2)
    final double availableWidth = screenWidth - 190.r;
    return 50.w + random.nextDouble() * availableWidth;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF1E3A8B)
        : const Color(0xFFF8FAFC);
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        int unlockedLevel = 1;
        if (state.status == AuthStatus.authenticated && state.user != null) {
          unlockedLevel = state.user!.unlockedLevels[gameType] ?? 1;
        }

        return Scaffold(
          backgroundColor: backgroundColor,
          body: Stack(
            children: [
              _buildBackground(context),
              SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // ── SliverAppBar ──
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      leadingWidth: 0,
                      automaticallyImplyLeading: false,
                      title: GlassTile(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        borderRadius: BorderRadius.circular(24.r),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ScaleButton(
                              onTap: () => context.pop(),
                              child: Container(
                                width: 28.r,
                                height: 28.r,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: primaryColor,
                                  size: 14.r,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "${KidsAssets.stickerMap[gameType]?[0] ?? '⭐'} ${title.toUpperCase()}",
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w900,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1E293B),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Map Segments ──
                    SliverPadding(
                      padding: EdgeInsets.symmetric(vertical: 60.h),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final level = index + 1;
                          final isLocked = level > unlockedLevel;
                          final isCurrent = level == unlockedLevel;
                          final isLast = index == 199;

                          final currentOffset = _getHorizontalOffset(
                            level,
                            screenWidth,
                          );
                          final nextOffset = isLast
                              ? currentOffset
                              : _getHorizontalOffset(level + 1, screenWidth);

                          return _buildMapSegment(
                            context,
                            level,
                            isLocked,
                            isCurrent,
                            isLast,
                            currentOffset,
                            nextOffset,
                            state.status == AuthStatus.unknown,
                          );
                        }, childCount: 200),
                      ),
                    ),
                  ],
                ),
              ),
              _buildBuddy(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBuddy(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final mascotId = authState.user?.kidsMascot ?? "owly";
        final emoji = KidsAssets.mascotMap[mascotId] ?? "🦉";
        final equippedStickerId = authState.user?.kidsEquippedSticker;
        final accessoryId = authState.user?.kidsEquippedAccessory;

        return Positioned(
          bottom: 20.h,
          right: 20.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: AnimatedKidsAsset(
                  emoji: emoji,
                  size: 50.r,
                  animation: KidsAssetAnimation.hover,
                ),
              ),
              if (accessoryId != null)
                Positioned(
                  top: -5.r,
                  left: -5.r,
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                    ),
                    child: Text(
                      KidsAssets.accessoryMap[accessoryId] ?? '',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
              if (equippedStickerId != null)
                Positioned(
                  top: -10.r,
                  right: -10.r,
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(
                      KidsAssets.getStickerEmoji(equippedStickerId),
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ).animate().scale(curve: Curves.elasticOut, duration: 800.ms),
                ),
            ],
          ).animate().slideX(begin: 1.0, curve: Curves.easeOutBack).fadeIn(),
        );
      },
    );
  }

  Widget _buildMapSegment(
    BuildContext context,
    int level,
    bool isLocked,
    bool isCurrent,
    bool isLast,
    double currentOffset,
    double nextOffset,
    bool isLoading,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return _buildShimmerSegment(context, currentOffset);
    }

    return CustomPaint(
      painter: SegmentPathPainter(
        color: isDark ? Colors.white.withAlpha(40) : primaryColor.withAlpha(60),
        currentOffset: currentOffset,
        nextOffset: nextOffset,
        isLast: isLast,
      ),
      child: Container(
        height: 200.h, // More space for organic curves
        padding: EdgeInsets.only(left: currentOffset),
        alignment: Alignment.centerLeft,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildLevelNode(context, level, isLocked, isCurrent)
                .animate()
                .fadeIn(duration: 800.ms, delay: (level % 5 * 100).ms)
                .scale(begin: const Offset(0.7, 0.7), curve: Curves.easeOutBack)
                .moveY(begin: 40, end: 0, curve: Curves.easeOutQuad),
            if (level == 10 || level == 50 || level == 100 || level == 200)
              _buildStickerGoal(level, isLocked),
          ],
        ),
      ),
    );
  }

  Widget _buildStickerGoal(int level, bool isLocked) {
    final stickerId = level == 10
        ? "sticker_$gameType"
        : "${gameType}_sticker_$level";
    final stickerEmoji = KidsAssets.getStickerEmoji(stickerId);

    return Positioned(
      top: -85.h,
      left: 0,
      right: 0,
      child:
          Column(
                children: [
                  Container(
                    width: 75.r,
                    height: 75.r,
                    decoration: BoxDecoration(
                      color: isLocked
                          ? Colors.grey[400]?.withValues(alpha: 0.1)
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isLocked
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.amber,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isLocked ? Colors.black : Colors.amber)
                              .withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: isLocked ? 10 : 0,
                          sigmaY: isLocked ? 10 : 0,
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedKidsAsset(
                                emoji: stickerEmoji,
                                size: 50.r,
                                animation: isLocked
                                    ? KidsAssetAnimation.none
                                    : KidsAssetAnimation.pulse,
                                color: isLocked
                                    ? Colors.grey[400]?.withValues(alpha: 0.3)
                                    : null,
                              ),
                              if (isLocked)
                                Container(
                                  padding: EdgeInsets.all(6.r),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '🔒',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isLocked
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.amber,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      isLocked ? "LVL $level GOAL" : "STICKER WON!",
                      style: GoogleFonts.outfit(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(
                begin: -5,
                end: 5,
                duration: 2.seconds,
                curve: Curves.easeInOutSine,
              ),
    );
  }

  Widget _buildShimmerSegment(BuildContext context, double offset) {
    return Container(
      height: 200.h,
      padding: EdgeInsets.only(left: offset),
      alignment: Alignment.centerLeft,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 100.r,
          height: 100.r,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        MeshGradientBackground(
          colors: isDark
              ? [
                  primaryColor.withAlpha(100),
                  const Color(0xFF1E3A8B),
                  primaryColor.withAlpha(80),
                ]
              : [
                  primaryColor.withAlpha(60),
                  const Color(0xFFF8FAFC),
                  primaryColor.withAlpha(40),
                ],
        ),
        // Decorative clouds
        Positioned(top: 100.h, left: -100.w, child: _buildCloud(context, 180.w))
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveX(
              begin: 0,
              end: 200,
              duration: 10.seconds,
              curve: Curves.easeInOutSine,
            ),

        Positioned(
              bottom: 250.h,
              right: -100.w,
              child: _buildCloud(context, 160.w),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveX(
              begin: 0,
              end: -250,
              duration: 14.seconds,
              curve: Curves.easeInOutSine,
            ),
      ],
    );
  }

  Widget _buildCloud(BuildContext context, double width) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Icon(
      Icons.cloud_rounded,
      color: (isDark ? Colors.white.withAlpha(15) : Colors.white).withAlpha(
        180,
      ),
      size: width,
    );
  }

  Widget _buildLevelNode(
    BuildContext context,
    int level,
    bool isLocked,
    bool isCurrent,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleButton(
      onTap: isLocked ? null : () => _navigateToGame(context, level),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isCurrent) _buildCurrentGlow(isDark),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 100.r, // Slightly larger nodes
                height: 100.r,
                decoration: BoxDecoration(
                  color: isLocked
                      ? (isDark
                            ? Colors.white.withAlpha(15)
                            : Colors.black.withAlpha(15))
                      : primaryColor.withAlpha(isDark ? 190 : 235),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isLocked
                        ? Colors.white.withAlpha(80)
                        : Colors.white, // Solid bright white border
                    width: isLocked ? 2.5.r : 5.r,
                  ),
                  boxShadow: [
                    if (!isLocked)
                      BoxShadow(
                        color: primaryColor.withAlpha(120),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                  ],
                ),
                child: Center(
                  child: isLocked
                      ? Icon(
                          Icons.lock_rounded,
                          color: Colors.white.withAlpha(160),
                          size: 34.sp,
                        )
                      : Text(
                          "$level",
                          style: GoogleFonts.poppins(
                            fontSize: 34.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentGlow(bool isDark) {
    return Container(
          width: 140.r,
          height: 140.r,
          decoration: BoxDecoration(
            color: primaryColor.withAlpha(isDark ? 90 : 60),
            shape: BoxShape.circle,
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .scale(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1.4, 1.4),
          duration: 2.5.seconds,
          curve: Curves.easeInOut,
        )
        .fadeOut(duration: 2.5.seconds);
  }

  void _navigateToGame(BuildContext context, int level) {
    final adService = di.sl<AdService>();
    final user = context.read<AuthBloc>().state.user;
    final isPremium = user?.isPremium ?? false;

    final routeMap = {
      'alphabet': AppRouter.kidsAlphabetRoute,
      'numbers': AppRouter.kidsNumbersRoute,
      'colors': AppRouter.kidsColorsRoute,
      'shapes': AppRouter.kidsShapesRoute,
      'animals': AppRouter.kidsAnimalsRoute,
      'fruits': AppRouter.kidsFruitsRoute,
      'family': AppRouter.kidsFamilyRoute,
      'school': AppRouter.kidsSchoolRoute,
      'verbs': AppRouter.kidsVerbsRoute,
      'routine': AppRouter.kidsRoutineRoute,
      'emotions': AppRouter.kidsEmotionsRoute,
      'prepositions': AppRouter.kidsPrepositionsRoute,
      'phonics': AppRouter.kidsPhonicsRoute,
      'time': AppRouter.kidsTimeRoute,
      'opposites': AppRouter.kidsOppositesRoute,
      'day_night': AppRouter.kidsDayNightRoute,
      'nature': AppRouter.kidsNatureRoute,
      'home_kids': AppRouter.kidsHomeRoute,
      'food_kids': AppRouter.kidsFoodRoute,
      'transport': AppRouter.kidsTransportRoute,
    };

    final route = routeMap[gameType];
    if (route != null) {
      adService.showInterstitialAd(
        isPremium: isPremium,
        onDismissed: () {
          if (context.mounted) {
            context.push(route, extra: level);
          }
        },
      );
    }
  }
}

class SegmentPathPainter extends CustomPainter {
  final Color color;
  final double currentOffset;
  final double nextOffset;
  final bool isLast;

  SegmentPathPainter({
    required this.color,
    required this.currentOffset,
    required this.nextOffset,
    required this.isLast,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isLast) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          16.0 // Chunkier path
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Start at the center of the current node
    final double startX = currentOffset + 50.r;
    final double startY = size.height / 2;

    // End at the center of the next node
    final double endX = nextOffset + 50.r;
    final double endY = size.height + (size.height / 2);

    path.moveTo(startX, startY);

    // Increase the organic feel with deeper Bezier control points
    final double controlPointDist = (startX - endX).abs() * 0.8 + 100.w;

    // Use a multi-segment curve for a "shaky/organic" snake look
    path.cubicTo(
      startX + (startX < endX ? controlPointDist : -controlPointDist),
      startY + (size.height * 0.6),
      endX + (startX < endX ? -controlPointDist : controlPointDist),
      startY + (size.height * 0.4),
      endX,
      endY,
    );

    // Draw dashed path
    final dashPath = _dashPath(path, 20.0, 18.0);
    canvas.drawPath(dashPath, paint);
  }

  Path _dashPath(Path source, double dashWidth, double dashSpace) {
    final path = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        path.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WindingPathPainter extends CustomPainter {
  // This class can be removed as we are now using SegmentPathPainter
  final Color lineColor;
  final int nodeCount;
  WindingPathPainter({required this.lineColor, required this.nodeCount});
  @override
  void paint(Canvas canvas, Size size) {}
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
