import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/animated_kids_asset.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/features/kids_zone/presentation/bloc/kids_bloc.dart';
import 'package:voxai_quest/core/utils/ad_service.dart';
import 'package:voxai_quest/core/utils/injection_container.dart' as di;
import 'package:voxai_quest/features/kids_zone/presentation/utils/kids_tts_service.dart';
import 'package:voxai_quest/features/kids_zone/presentation/widgets/kids_feedback_overlay.dart';
import 'package:voxai_quest/core/utils/analytics_service.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:voxai_quest/features/kids_zone/presentation/utils/kids_assets.dart';
import 'package:voxai_quest/features/kids_zone/presentation/utils/kids_audio_service.dart';

class KidsGameBaseScreen extends StatefulWidget {
  final String title;
  final String gameType;
  final int level;
  final Color primaryColor;
  final List<Color> backgroundColors;
  final Widget Function(BuildContext context, KidsLoaded state) buildGameUI;

  const KidsGameBaseScreen({
    super.key,
    required this.title,
    required this.gameType,
    required this.level,
    required this.primaryColor,
    required this.backgroundColors,
    required this.buildGameUI,
  });

  @override
  State<KidsGameBaseScreen> createState() => _KidsGameBaseScreenState();
}

class _KidsGameBaseScreenState extends State<KidsGameBaseScreen> {
  @override
  void initState() {
    super.initState();
    context.read<KidsBloc>().add(
      FetchKidsQuests(widget.gameType, widget.level),
    );
    // Start background music
    di.sl<KidsAudioService>().startBgm();
  }

  @override
  void dispose() {
    // Stop BGM when leaving game
    di.sl<KidsAudioService>().stopBgm();
    super.dispose();
  }

  Future<void> _speakInstruction(String instruction) async {
    try {
      final tts = di.sl<KidsTTSService>();
      if (await tts.isNarrationEnabled()) {
        await tts.speak(instruction);
      }
    } catch (e) {
      debugPrint("KIDS_TTS_ERROR: $e");
    }
  }

  void _greetUser() {
    final greetings = [
      "You're doing great! Keep it up!",
      "I believe in you! Let's solve this!",
      "Wow, you're getting faster!",
      "You're a superstar learner!",
      "Let's find the answer together!",
    ];
    greetings.shuffle();
    _speakInstruction(greetings.first);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF1E3A8A)
        : const Color(0xFFF8FAFC);

    // Theme-aware background colors if none provided
    final List<Color> bgColors = widget.backgroundColors.isNotEmpty
        ? widget.backgroundColors
        : (isDark
              ? [const Color(0xFF1E3A8A), const Color(0xFF1E1B4B)]
              : [const Color(0xFFE0F2FE), const Color(0xFFF0FDF4)]);

    return BlocConsumer<KidsBloc, KidsState>(
      listener: (context, state) {
        final audio = di.sl<KidsAudioService>();
        if (state is KidsGameComplete) {
          audio.playLevelCompleteSFX();
          _showCompletionDialog(context, state);
        } else if (state is KidsGameOver) {
          audio.playFailureSFX();
          _showGameOverDialog(context);
        } else if (state is KidsLoaded) {
          // Play success/wrong SFX
          if (state.lastAnswerCorrect == true) {
            audio.playSuccessSFX();
          } else if (state.lastAnswerCorrect == false) {
            audio.playFailureSFX();
          }

          // Auto-speak instruction when a NEW question loads
          if (state.lastAnswerCorrect == null) {
            _speakInstruction(state.currentQuest.instruction);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? bgColors
                          .map(
                            (c) => Color.alphaBlend(
                              Colors.black.withValues(alpha: 0.4),
                              c,
                            ),
                          )
                          .toList()
                    : bgColors,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, state),
                  Expanded(child: _buildBody(context, state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, KidsState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : widget.primaryColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ScaleButton(
            onTap: () => context.pop(),
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                  ),
                ],
                border: isDark ? Border.all(color: Colors.white12) : null,
              ),
              child: Icon(
                Icons.close,
                color: isDark ? Colors.white : widget.primaryColor,
                size: 24.sp,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  shadows: isDark
                      ? [
                          Shadow(
                            color: widget.primaryColor.withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
          Row(
            children: [
              _buildLives(state),
              SizedBox(width: 8.w),
              _buildAudioToggle(isDark),
              SizedBox(width: 8.w),
              _buildNarrationToggle(isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioToggle(bool isDark) {
    final audio = di.sl<KidsAudioService>();
    return FutureBuilder<bool>(
      future: audio.isBgmEnabled(),
      builder: (context, snapshot) {
        final isEnabled = snapshot.data ?? true;
        return ScaleButton(
          onTap: () async {
            await audio.setBgmEnabled(!isEnabled);
            await audio.setSfxEnabled(!isEnabled);
            setState(() {});
            if (!isEnabled) {
              audio.startBgm();
            }
          },
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: isEnabled
                  ? Colors.orangeAccent
                  : (isDark ? Colors.white10 : Colors.grey[300]),
              shape: BoxShape.circle,
              border: isDark && !isEnabled
                  ? Border.all(color: Colors.white12)
                  : null,
            ),
            child: Icon(
              isEnabled ? Icons.music_note_rounded : Icons.music_off_rounded,
              color: isEnabled
                  ? Colors.white
                  : (isDark ? Colors.white38 : Colors.grey[600]),
              size: 18.sp,
            ),
          ),
        );
      },
    );
  }

  Widget _buildNarrationToggle(bool isDark) {
    final tts = di.sl<KidsTTSService>();
    return FutureBuilder<bool>(
      future: tts.isNarrationEnabled(),
      builder: (context, snapshot) {
        final isEnabled = snapshot.data ?? true;
        return ScaleButton(
          onTap: () async {
            await tts.setNarrationEnabled(!isEnabled);
            if (!context.mounted) return;
            setState(() {}); // Refresh icon
            if (!isEnabled) {
              final state = context.read<KidsBloc>().state;
              if (state is KidsLoaded) {
                _speakInstruction(state.currentQuest.instruction);
              }
            }
          },
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: isEnabled
                  ? widget.primaryColor
                  : (isDark ? Colors.white10 : Colors.grey[300]),
              shape: BoxShape.circle,
              border: isDark && !isEnabled
                  ? Border.all(color: Colors.white12)
                  : null,
            ),
            child: Icon(
              isEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: isEnabled
                  ? Colors.white
                  : (isDark ? Colors.white38 : Colors.grey[600]),
              size: 18.sp,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLives(KidsState state) {
    int lives = 3;
    if (state is KidsLoaded) {
      lives = state.livesRemaining;
    }
    return Row(
      children: List.generate(3, (index) {
        return Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Icon(
            index < lives ? Icons.favorite : Icons.favorite_border,
            color: Colors.redAccent,
            size: 22.sp,
          ),
        );
      }),
    );
  }

  Widget _buildBody(BuildContext context, KidsState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (state is KidsLoading) {
      return Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Shimmer.fromColors(
                baseColor: isDark ? Colors.white12 : Colors.grey[300]!,
                highlightColor: isDark ? Colors.white24 : Colors.grey[100]!,
                child: Container(
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (state is KidsLoaded) {
      try {
        return Stack(
          children: [
            widget.buildGameUI(context, state),
            _buildBuddy(context),
            if (state.lastAnswerCorrect != null)
              KidsFeedbackOverlay(
                isCorrect: state.lastAnswerCorrect!,
                onTap: () {
                  context.read<KidsBloc>().add(NextKidsQuestion());
                },
              ),
          ],
        );
      } catch (e) {
        debugPrint("KIDS_UI_BUILD_ERROR: $e");
        return Center(
          child: Text(
            "Oops! This game needs a little fix. 🛠️",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        );
      }
    } else if (state is KidsError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(30.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AnimatedKidsAsset(
                emoji: '🎈',
                size: 150,
                animation: KidsAssetAnimation.hover,
              ),
              SizedBox(height: 20.h),
              Text(
                "NICE TRY!",
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : widget.primaryColor,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "This game level is taking a nap. \nCheck back soon! 🎈",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
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
          child: GestureDetector(
            onTap: _greetUser,
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
                    child:
                        Container(
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
                        ).animate().scale(
                          curve: Curves.elasticOut,
                          duration: 800.ms,
                        ),
                  ),
              ],
            ),
          ).animate().slideX(begin: 1.0, curve: Curves.easeOutBack).fadeIn(),
        );
      },
    );
  }

  void _showCompletionDialog(BuildContext context, KidsGameComplete state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final adService = di.sl<AdService>();
    final user = context.read<AuthBloc>().state.user;
    final isPremium = user?.isPremium ?? false;
    bool rewardsDoubled = false;

    void onFinished() {
      if (mounted) {
        context.pop(); // Close dialog
        context.pop(); // Go back to level map
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
            title: Center(
              child: Text(
                "LEVEL UP!",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : widget.primaryColor,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars_rounded, color: Colors.orange, size: 80.sp),
                SizedBox(height: 20.h),
                Text(
                  "You earned ${state.xpEarned} XP and ${state.coinsEarned} Coins!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                if (rewardsDoubled)
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Text(
                      "+ Bonus Rewards Added! ✨",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                if (state.stickerAwarded != null) ...[
                  SizedBox(height: 25.h),
                  Container(
                    padding: EdgeInsets.all(15.r),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "NEW STICKER!",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w900,
                            color: Colors.amber[800],
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        const AnimatedKidsAsset(
                          emoji: '🎉',
                          size: 100,
                          animation: KidsAssetAnimation.bounce,
                        ),
                      ],
                    ),
                  ).animate().scale(delay: 500.ms).shake(),
                ],
              ],
            ),
            actions: [
              Column(
                children: [
                  if (!rewardsDoubled)
                    Center(
                      child: ScaleButton(
                        onTap: () {
                          if (isPremium) {
                            context.read<KidsBloc>().add(
                              ClaimDoubleKidsRewards(
                                widget.gameType,
                                widget.level,
                              ),
                            );
                            setDialogState(() {
                              rewardsDoubled = true;
                            });
                          } else {
                            adService.showRewardedAd(
                              isPremium: isPremium,
                              onUserEarnedReward: (reward) {
                                context.read<KidsBloc>().add(
                                  ClaimDoubleKidsRewards(
                                    widget.gameType,
                                    widget.level,
                                  ),
                                );
                                setDialogState(() {
                                  rewardsDoubled = true;
                                });
                              },
                              onDismissed: () {},
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPremium
                                    ? Icons.stars_rounded
                                    : Icons.play_circle_fill_rounded,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "DOUBLE REWARDS",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 12.h),
                  Center(
                    child: ScaleButton(
                      onTap: onFinished,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 15.h,
                        ),
                        decoration: BoxDecoration(
                          color: widget.primaryColor,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: widget.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          "FINISH",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          );
        },
      ),
    );
  }

  void _showGameOverDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final adService = di.sl<AdService>();
    final analytics = di.sl<AnalyticsService>();
    final user = context.read<AuthBloc>().state.user;
    final isPremium = user?.isPremium ?? false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        title: Center(
          child: Text(
            "DON'T GIVE UP!",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        content: Text(
          "Get back in the game and keep your progress!",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        actions: [
          Column(
            children: [
              Center(
                child: ScaleButton(
                  onTap: () {
                    void restoreLife() {
                      analytics.logRescueLifeUsed(
                        widget.gameType,
                        widget.level,
                      );
                      context.read<KidsBloc>().add(RestoreKidsLife());
                      context.pop(); // Close dialog
                    }

                    if (isPremium) {
                      restoreLife();
                    } else {
                      adService.showRewardedAd(
                        isPremium: false,
                        onUserEarnedReward: (_) {
                          restoreLife();
                        },
                        onDismissed: () {},
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isPremium ? Icons.favorite : Icons.play_circle_fill,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          isPremium ? "CONTINUE" : "WATCH AD TO CONTINUE",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Center(
                child: ScaleButton(
                  onTap: () {
                    analytics.logLevelFail(widget.gameType, widget.level);
                    context.pop();
                    context.pop();
                  },
                  child: Text(
                    "GIVE UP",
                    style: GoogleFonts.poppins(
                      color: isDark ? Colors.white54 : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ],
      ),
    );
  }
}
