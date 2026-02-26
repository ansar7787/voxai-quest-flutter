import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voxai_quest/core/presentation/widgets/mesh_gradient_background.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/core/presentation/widgets/ad_reward_card.dart';
import 'package:voxai_quest/core/utils/app_router.dart';
import 'package:voxai_quest/features/kids_zone/presentation/utils/kids_assets.dart';

class KidsZoneScreen extends StatefulWidget {
  const KidsZoneScreen({super.key});

  @override
  State<KidsZoneScreen> createState() => _KidsZoneScreenState();
}

class _KidsZoneScreenState extends State<KidsZoneScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF1E3A8A)
        : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          MeshGradientBackground(
            colors: isDark
                ? [
                    const Color(0xFF4F46E5),
                    const Color(0xFF7C3AED),
                    const Color(0xFF1E3A8A),
                  ]
                : [
                    const Color(0xFFFFE4E6),
                    const Color(0xFFE0F2FE),
                    const Color(0xFFF0FDF4),
                  ],
          ),
          ..._buildFloatingBackgroundElements(),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, isDark),
              _buildHeaderSection(context, isDark),
              _buildModernCategorySection(context),
              const SliverToBoxAdapter(child: AdRewardCard()),
              SliverToBoxAdapter(child: SizedBox(height: 100.h)),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingBackgroundElements() {
    return [
      _buildFloatingMascot('🦉', top: 150.h, left: -40.w, size: 80.r, delay: 0),
      _buildFloatingMascot(
        '⭐',
        top: 400.h,
        right: -30.w,
        size: 60.r,
        delay: 500,
      ),
      _buildFloatingMascot(
        '🌈',
        bottom: 200.h,
        left: 20.w,
        size: 70.r,
        delay: 1000,
      ),
      _buildFloatingMascot(
        '🎨',
        top: 600.h,
        left: -20.w,
        size: 50.r,
        delay: 1500,
      ),
    ];
  }

  Widget _buildFloatingMascot(
    String emoji, {
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required int delay,
  }) {
    return Positioned(
          top: top,
          bottom: bottom,
          left: left,
          right: right,
          child: Opacity(
            opacity: 0.1,
            child: Text(emoji, style: TextStyle(fontSize: size)),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: -20,
          end: 20,
          duration: 3.seconds + delay.ms,
          curve: Curves.easeInOutSine,
        )
        .rotate(
          begin: -0.1,
          end: 0.1,
          duration: 5.seconds + delay.ms,
          curve: Curves.easeInOutSine,
        );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(8.r),
        child: ScaleButton(
          onTap: () => context.pop(),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF6366F1),
              size: 18,
            ),
          ),
        ),
      ),
      actions: [
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final coins = state.user?.kidsCoins ?? 0;
            return Container(
              margin: EdgeInsets.only(right: 16.w, top: 8.h, bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.toys_rounded,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "$coins",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeaderSection(BuildContext context, bool isDark) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 20.h),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  "KIDS ZONE",
                  style: GoogleFonts.outfit(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                    letterSpacing: -1,
                  ),
                ).animate().fadeIn().scale(delay: 200.ms),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    "ADVENTURE HUB",
                    style: GoogleFonts.outfit(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF6366F1),
                      letterSpacing: 2,
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms),
              ],
            ),
            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildModernHeaderAction(
                  context,
                  () => context.push(AppRouter.kidsMascotSelectionRoute),
                  'Buddy',
                  context.watch<AuthBloc>().state.user?.kidsMascot ?? 'owly',
                  const Color(0xFF6366F1),
                  0,
                ),
                _buildModernHeaderAction(
                  context,
                  () => context.push(AppRouter.kidsStickerBookRoute),
                  'Album',
                  '⭐',
                  Colors.amber,
                  1,
                ),
                _buildModernHeaderAction(
                  context,
                  () => context.pushNamed('kids-boutique'),
                  'Boutique',
                  '🛍️',
                  const Color(0xFFEF4444),
                  2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeaderAction(
    BuildContext context,
    VoidCallback onTap,
    String label,
    String mascotIdOrEmoji,
    Color color,
    int index,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String displayEmoji = mascotIdOrEmoji;
    if (KidsAssets.mascotMap.containsKey(mascotIdOrEmoji)) {
      displayEmoji = KidsAssets.mascotMap[mascotIdOrEmoji]!;
    }
    return ScaleButton(
      onTap: onTap,
      child:
          Column(
                children: [
                  Container(
                    width: 70.r,
                    height: 70.r,
                    decoration: BoxDecoration(
                      color: isDark
                          ? color.withValues(alpha: 0.2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        displayEmoji,
                        style: TextStyle(fontSize: 32.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    label.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white70 : const Color(0xFF1E293B),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(delay: (index * 100 + 600).ms)
              .scale(curve: Curves.easeOutBack),
    );
  }

  Widget _buildModernCategorySection(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final completedData = state.user?.completedLevels ?? {};
        final categories = [
          (
            'Alphabet',
            'A B C',
            Icons.font_download_rounded,
            const Color(0xFFF43F5E),
            'alphabet',
          ),
          (
            'Numbers',
            '1 2 3',
            Icons.numbers_rounded,
            const Color(0xFF0EA5E9),
            'numbers',
          ),
          (
            'Colors',
            'Rainbow',
            Icons.color_lens_rounded,
            const Color(0xFFF59E0B),
            'colors',
          ),
          (
            'Shapes',
            'Circle...',
            Icons.category_rounded,
            const Color(0xFF10B981),
            'shapes',
          ),
          (
            'Animals',
            'Pets',
            Icons.pets_rounded,
            const Color(0xFF6366F1),
            'animals',
          ),
          (
            'Fruits',
            'Yummy!',
            Icons.apple_rounded,
            const Color(0xFFEF4444),
            'fruits',
          ),
          (
            'Family',
            'My People',
            Icons.people_rounded,
            const Color(0xFFEC4899),
            'family',
          ),
          (
            'School',
            'Learning',
            Icons.school_rounded,
            const Color(0xFFF59E0B),
            'school',
          ),
          (
            'Verbs',
            'Actions',
            Icons.directions_run_rounded,
            const Color(0xFF8B5CF6),
            'verbs',
          ),
          (
            'Routine',
            'My Day',
            Icons.wb_sunny_rounded,
            const Color(0xFFF97316),
            'routine',
          ),
          (
            'Emotions',
            'Feelings',
            Icons.mood_rounded,
            const Color(0xFF06B6D4),
            'emotions',
          ),
          (
            'Prepositions',
            'Where?',
            Icons.place_rounded,
            const Color(0xFF64748B),
            'prepositions',
          ),
          (
            'Phonics',
            'Sounds',
            Icons.record_voice_over_rounded,
            const Color(0xFFFFCC00),
            'phonics',
          ),
          (
            'Time',
            'Tick Tock',
            Icons.access_time_filled_rounded,
            const Color(0xFF333333),
            'time',
          ),
          (
            'Opposites',
            'Big/Small',
            Icons.compare_arrows_rounded,
            const Color(0xFF94A3B8),
            'opposites',
          ),
          (
            'Day/Night',
            'Sun/Moon',
            Icons.nights_stay_rounded,
            const Color(0xFF1E293B),
            'day_night',
          ),
          (
            'Nature',
            'Outdoors',
            Icons.forest_rounded,
            const Color(0xFF16A34A),
            'nature',
          ),
          (
            'Home',
            'House',
            Icons.home_rounded,
            const Color(0xFFD946EF),
            'home_kids',
          ),
          (
            'Food',
            'Yummy!',
            Icons.restaurant_rounded,
            const Color(0xFFFB923C),
            'food_kids',
          ),
          (
            'Transport',
            'Vroom!',
            Icons.directions_car_rounded,
            const Color(0xFF2563EB),
            'transport',
          ),
        ];

        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              // Creating a staggered "island" effect by grouping into rows of 1 or 2
              if (index >= (categories.length / 2).ceil()) return null;

              final firstIdx = index * 2;
              final secondIdx = firstIdx + 1;

              return Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildBubblyCard(
                        context,
                        categories[firstIdx],
                        completedData[categories[firstIdx].$5]?.length ?? 0,
                        true,
                      ),
                    ),
                    if (secondIdx < categories.length) ...[
                      SizedBox(width: 20.w),
                      Expanded(
                        child: _buildBubblyCard(
                          context,
                          categories[secondIdx],
                          completedData[categories[secondIdx].$5]?.length ?? 0,
                          false,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }, childCount: (categories.length / 2).ceil()),
          ),
        );
      },
    );
  }

  Widget _buildBubblyCard(
    BuildContext context,
    dynamic cat,
    int completedLevels,
    bool isLarge,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = cat.$4 as Color;
    final progress = (completedLevels / 10).clamp(0.0, 1.0);

    return ScaleButton(
          onTap: () {
            context.push(
              '/kids-level-map',
              extra: {
                'gameType': cat.$5,
                'title': cat.$1,
                'primaryColor': color,
              },
            );
          },
          child: Container(
            height: isLarge ? 200.h : 180.h,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.white,
              borderRadius: BorderRadius.circular(36.r),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: color.withValues(alpha: 0.1), width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36.r),
              child: Stack(
                children: [
                  Positioned(
                    top: -20,
                    right: -20,
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundColor: color.withValues(alpha: 0.05),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            cat.$3 as IconData,
                            color: color,
                            size: 28.r,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          cat.$1 as String,
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1E293B),
                            height: 1.1,
                          ),
                        ),
                        Text(
                          cat.$2 as String,
                          style: GoogleFonts.outfit(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildModernProgressBar(color, progress),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(
          begin: 0,
          end: isLarge ? 5 : -5,
          duration: 2.seconds,
          curve: Curves.easeInOutSine,
        )
        .animate()
        .fadeIn(delay: 400.ms)
        .slideY(begin: 0.1);
  }

  Widget _buildModernProgressBar(Color color, double progress) {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3.r),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
