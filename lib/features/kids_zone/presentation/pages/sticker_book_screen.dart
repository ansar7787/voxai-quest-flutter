import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/animated_kids_asset.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/features/kids_zone/presentation/utils/kids_assets.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class StickerBookScreen extends StatefulWidget {
  const StickerBookScreen({super.key});

  @override
  State<StickerBookScreen> createState() => _StickerBookScreenState();
}

class _StickerBookScreenState extends State<StickerBookScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        if (user == null) return const SizedBox.shrink();

        final totalEarned = user.kidsStickers.length;
        const totalMax = 80;
        final mascotEmoji = KidsAssets.mascotMap[user.kidsMascot] ?? '🦉';

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Bubbly background decorations
              Positioned(
                top: -50,
                right: -50,
                child: CircleAvatar(
                  radius: 120.r,
                  backgroundColor: const Color(
                    0xFF6366F1,
                  ).withValues(alpha: 0.03),
                ),
              ),
              Positioned(
                bottom: 100,
                left: -40,
                child: CircleAvatar(
                  radius: 80.r,
                  backgroundColor: Colors.orange.withValues(alpha: 0.03),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _buildPremiumAppBar(
                      context,
                      totalEarned,
                      totalMax,
                      mascotEmoji,
                    ),
                    Expanded(child: _buildStickerList(state)),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Colors.orange,
                    Colors.pink,
                    Colors.blue,
                    Colors.yellow,
                    Colors.purple,
                  ],
                  maxBlastForce: 20,
                  minBlastForce: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPremiumAppBar(
    BuildContext context,
    int earned,
    int max,
    String mascotEmoji,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ScaleButton(
                onTap: () => context.pop(),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF1E293B),
                    size: 20,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Text(mascotEmoji, style: TextStyle(fontSize: 18.sp)),
                    SizedBox(width: 8.w),
                    Text(
                      "$earned / $max",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.orange[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Column(
            children: [
              Text(
                "STICKERS ALBUM",
                style: GoogleFonts.outfit(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E293B),
                  letterSpacing: -0.5,
                  height: 1,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ],
          ).animate().fadeIn().scale(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildStickerList(AuthState state) {
    final categories = KidsAssets.stickerMap.keys.toList();

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 40.h),
      physics: const BouncingScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildModernCategorySection(context, category, state, index);
      },
    );
  }

  Widget _buildModernCategorySection(
    BuildContext context,
    String category,
    AuthState state,
    int sectionIndex,
  ) {
    final milestones = [10, 50, 100, 200];
    final earnedStickers = state.user?.kidsStickers ?? [];
    final categoryName = category.toUpperCase().replaceAll('_', ' ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(4.w, 32.h, 4.w, 16.h),
          child: Row(
            children: [
              Text(
                categoryName,
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E293B).withValues(alpha: 0.8),
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "${milestones.where((m) => earnedStickers.contains(m == 10 ? "sticker_$category" : "${category}_sticker_$m")).length}/4",
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.black45,
                  ),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.w,
            childAspectRatio: 0.85,
          ),
          itemCount: milestones.length,
          itemBuilder: (context, mIndex) {
            final level = milestones[mIndex];
            final stickerId = level == 10
                ? "sticker_$category"
                : "${category}_sticker_$level";
            final isUnlocked = earnedStickers.contains(stickerId);

            return _buildModernStickerItem(
              context,
              category,
              stickerId,
              isUnlocked,
              level,
              mIndex,
            );
          },
        ),
      ],
    ).animate().fadeIn(delay: (sectionIndex * 50).ms).slideY(begin: 0.05);
  }

  Widget _buildModernStickerItem(
    BuildContext context,
    String category,
    String stickerId,
    bool isUnlocked,
    int level,
    int index,
  ) {
    final user = context.watch<AuthBloc>().state.user;
    final equippedStickerId = user?.kidsEquippedSticker;
    final isEquipped = equippedStickerId == stickerId;
    final stickerEmoji = KidsAssets.getStickerEmoji(stickerId);

    return ScaleButton(
      onTap: isUnlocked
          ? () {
              if (!isEquipped) {
                _confettiController.play();
                Haptics.vibrate(HapticsType.heavy);
              } else {
                Haptics.vibrate(HapticsType.medium);
              }
              context.read<AuthBloc>().add(
                AuthUpdateUser(
                  user!.copyWith(
                    kidsEquippedSticker: isEquipped ? null : stickerId,
                  ),
                ),
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked
              ? Colors.white
              : Colors.black.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: isEquipped
                        ? Colors.orange.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
          border: Border.all(
            color: isEquipped
                ? Colors.orange
                : (isUnlocked
                      ? Colors.black.withValues(alpha: 0.05)
                      : Colors.transparent),
            width: isEquipped ? 2.0 : 1.0,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isUnlocked)
                      Container(
                        width: 48.r,
                        height: 48.r,
                        decoration: BoxDecoration(
                          color: isEquipped
                              ? Colors.orange.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.01),
                          shape: BoxShape.circle,
                        ),
                      ),
                    AnimatedKidsAsset(
                      emoji: stickerEmoji,
                      size: 42.r,
                      animation: isUnlocked
                          ? (isEquipped
                                ? KidsAssetAnimation.pulse
                                : KidsAssetAnimation.bounce)
                          : KidsAssetAnimation.none,
                      color: isUnlocked
                          ? null
                          : Colors.black.withValues(alpha: 0.08),
                    ),
                    if (!isUnlocked)
                      Icon(
                        Icons.lock_rounded,
                        size: 20.r,
                        color: Colors.black.withValues(alpha: 0.06),
                      ),
                  ],
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? (isEquipped
                              ? Colors.orange
                              : Colors.black.withValues(alpha: 0.04))
                        : Colors.black.withValues(alpha: 0.02),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "LVL $level",
                    style: GoogleFonts.outfit(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w900,
                      color: isUnlocked
                          ? (isEquipped ? Colors.white : Colors.black54)
                          : Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                ),
              ],
            ),
            if (isEquipped)
              Positioned(
                top: 8.r,
                right: 8.r,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 8.r),
                ),
              ).animate().scale(duration: 300.ms, curve: Curves.bounceOut),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).scale(duration: 300.ms);
  }
}
