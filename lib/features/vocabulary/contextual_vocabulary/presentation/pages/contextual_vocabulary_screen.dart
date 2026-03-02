import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/core/presentation/pages/quest_unavailable_screen.dart';
import 'package:voxai_quest/core/presentation/themes/level_theme_helper.dart';
import 'package:voxai_quest/core/presentation/widgets/game_confetti.dart';
import 'package:voxai_quest/core/presentation/widgets/glass_tile.dart';
import 'package:voxai_quest/core/presentation/widgets/mesh_gradient_background.dart';
import 'package:voxai_quest/core/presentation/widgets/modern_game_dialog.dart';
import 'package:voxai_quest/core/presentation/widgets/modern_game_result_overlay.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/core/presentation/widgets/shimmer_loading.dart';
import 'package:voxai_quest/core/presentation/widgets/vocabulary/golden_dust.dart';
import 'package:voxai_quest/core/utils/ad_service.dart';
import 'package:voxai_quest/core/utils/haptic_service.dart';
import 'package:voxai_quest/core/utils/injection_container.dart' as di;
import 'package:voxai_quest/core/utils/sound_service.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voxai_quest/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';

class ContextualVocabularyScreen extends StatefulWidget {
  final int level;
  const ContextualVocabularyScreen({super.key, required this.level});

  @override
  State<ContextualVocabularyScreen> createState() =>
      _ContextualVocabularyScreenState();
}

class _ContextualVocabularyScreenState
    extends State<ContextualVocabularyScreen> {
  final _hapticService = di.sl<HapticService>();
  final _soundService = di.sl<SoundService>();
  int? _selectedOptionIndex;
  bool _showConfetti = false;

  void _useHint() {
    _hapticService.selection();
    context.read<VocabularyBloc>().add(VocabularyHintUsed());
  }

  @override
  void initState() {
    super.initState();
    context.read<VocabularyBloc>().add(
      FetchVocabularyQuests(
        gameType: GameSubtype.contextClues,
        level: widget.level,
      ),
    );
  }

  void _submitAnswer(int index, int correctIndex) {
    if (_selectedOptionIndex != null) return;
    _hapticService.selection();
    setState(() => _selectedOptionIndex = index);

    bool isCorrect = (index == correctIndex);
    if (isCorrect) {
      _soundService.playCorrect();
      _hapticService.success();
    } else {
      _soundService.playWrong();
      _hapticService.error();
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<VocabularyBloc>().add(SubmitAnswer(isCorrect));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = LevelThemeHelper.getTheme(
      'vocabulary',
      level: widget.level,
      isDark: isDark,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<VocabularyBloc, VocabularyState>(
        listener: (context, state) {
          if (state is VocabularyGameComplete) {
            setState(() => _showConfetti = true);
            final isPremium =
                context.read<AuthBloc>().state.user?.isPremium ?? false;
            di.sl<AdService>().showInterstitialAd(
              isPremium: isPremium,
              onDismissed: () => _showCompletionDialog(
                context,
                state.xpEarned,
                state.coinsEarned,
              ),
            );
          } else if (state is VocabularyGameOver) {
            _showGameOverDialog(context);
          } else if (state is VocabularyLoaded &&
              state.lastAnswerCorrect == null) {
            setState(() => _selectedOptionIndex = null);
          }
        },
        builder: (context, state) {
          if (state is VocabularyLoading || state is VocabularyInitial) {
            return const GameShimmerLoading();
          }
          if (state is VocabularyLoaded) {
            return Stack(
              children: [
                MeshGradientBackground(colors: theme.backgroundColors),
                GoldenDust(color: theme.primaryColor),
                _buildGameUI(context, state, isDark, theme),
              ],
            );
          }
          if (state is VocabularyError) {
            return QuestUnavailableScreen(
              message: state.message,
              onRetry: () => context.read<VocabularyBloc>().add(
                FetchVocabularyQuests(
                  gameType: GameSubtype.contextClues,
                  level: widget.level,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGameUI(
    BuildContext context,
    VocabularyLoaded state,
    bool isDark,
    ThemeResult theme,
  ) {
    final quest = state.currentQuest;
    final progress = (state.currentIndex + 1) / state.quests.length;

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 10.h),
              child: Row(
                children: [
                  ScaleButton(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.black12,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 24.r,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 14.h,
                        backgroundColor: isDark
                            ? Colors.white10
                            : Colors.black12,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  _buildHintButton(state.hintUsed, theme.primaryColor),
                  SizedBox(width: 12.w),
                  _buildHeartCount(state.livesRemaining),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      "WORD WEAVER",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      quest.instruction,
                      style: GoogleFonts.outfit(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),

                    // Context Card
                    GlassTile(
                      padding: EdgeInsets.all(32.r),
                      borderRadius: BorderRadius.circular(32.r),
                      borderColor: theme.primaryColor.withValues(alpha: 0.3),
                      color: isDark
                          ? theme.primaryColor.withValues(alpha: 0.05)
                          : Colors.white.withValues(alpha: 0.5),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: theme.primaryColor.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Text(
                              "CONTEXT ANALYSIS",
                              style: GoogleFonts.outfit(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            quest.word ?? "Context Word",
                            style: GoogleFonts.outfit(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w900,
                              color: theme.primaryColor,
                              letterSpacing: 2,
                            ),
                          ),
                          if (quest.sentence != null) ...[
                            SizedBox(height: 24.h),
                            Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.black26 : Colors.white24,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: theme.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                              ),
                              child: Text(
                                "\"${quest.sentence}\"",
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontStyle: FontStyle.italic,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),

                    SizedBox(height: 40.h),

                    // Options
                    ...List.generate(quest.options?.length ?? 0, (index) {
                      final isSelected = _selectedOptionIndex == index;
                      final isCorrect = index == quest.correctAnswerIndex;

                      Color bgColor = isDark
                          ? const Color(0xFF1E293B)
                          : Colors.white;
                      Color borderColor = isDark
                          ? Colors.white10
                          : Colors.black.withValues(alpha: 0.05);

                      if (_selectedOptionIndex != null && isSelected) {
                        bgColor = isCorrect ? Colors.green : Colors.red;
                        borderColor = bgColor;
                      } else if (_selectedOptionIndex != null && isCorrect) {
                        // Optional: Highlight correct even if not selected
                        borderColor = Colors.green.withValues(alpha: 0.5);
                      }

                      return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: ScaleButton(
                              onTap: () => _submitAnswer(
                                index,
                                quest.correctAnswerIndex ?? 0,
                              ),
                              child: GlassTile(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 18.h,
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                                color: bgColor.withValues(alpha: 0.8),
                                borderColor: borderColor.withValues(alpha: 0.3),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40.r,
                                      height: 40.r,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            isSelected
                                                ? Colors.white24
                                                : theme.primaryColor.withValues(
                                                    alpha: 0.1,
                                                  ),
                                            isSelected
                                                ? Colors.white10
                                                : theme.primaryColor.withValues(
                                                    alpha: 0.05,
                                                  ),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.white24
                                              : theme.primaryColor.withValues(
                                                  alpha: 0.2,
                                                ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          String.fromCharCode(64 + (index + 1)),
                                          style: GoogleFonts.outfit(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w900,
                                            color: isSelected
                                                ? Colors.white
                                                : theme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 18.w),
                                    Expanded(
                                      child: Text(
                                        quest.options![index],
                                        style: GoogleFonts.outfit(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? Colors.white
                                              : (isDark
                                                    ? Colors.white.withValues(
                                                        alpha: 0.9,
                                                      )
                                                    : Colors.black87),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    if (_selectedOptionIndex != null &&
                                        isCorrect)
                                      Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.white,
                                        size: 24.r,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(
                            delay: Duration(milliseconds: 300 + (index * 100)),
                          )
                          .slideX(begin: 0.1);
                    }),

                    SizedBox(height: 48.h),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (state.lastAnswerCorrect != null)
          ModernGameResultOverlay(
            isCorrect: state.lastAnswerCorrect!,
            title: state.lastAnswerCorrect! ? "CONTEXT MASTER!" : "ALMOST!",
            subtitle: quest.explanation,
            onContinue: () =>
                context.read<VocabularyBloc>().add(NextQuestion()),
            primaryColor: theme.primaryColor,
          ),
        if (_showConfetti) const GameConfetti(),
      ],
    );
  }

  Widget _buildHeartCount(int lives) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.pink.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_rounded, color: Colors.pinkAccent, size: 20.r),
          SizedBox(width: 6.w),
          Text(
            "$lives",
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: Colors.pinkAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHintButton(bool used, Color primaryColor) {
    return ScaleButton(
      onTap: used ? null : _useHint,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: used
              ? Colors.grey.withValues(alpha: 0.1)
              : primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: used
                ? Colors.grey.withValues(alpha: 0.3)
                : primaryColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              used ? Icons.lightbulb_outline_rounded : Icons.lightbulb_rounded,
              color: used ? Colors.grey : primaryColor,
              size: 20.r,
            ),
            SizedBox(width: 6.w),
            Text(
              "HINT",
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: used ? Colors.grey : primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  void _showCompletionDialog(BuildContext context, int xp, int coins) {
    _soundService.playLevelComplete();
    _hapticService.success();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ModernGameDialog(
        title: 'Context Pro!',
        description:
            'You earned $xp XP and $coins Coins for understanding the nuances!',
        buttonText: 'GREAT',
        onButtonPressed: () {
          Navigator.pop(c);
          context.pop();
        },
      ),
    );
  }

  void _showGameOverDialog(BuildContext context) {
    _hapticService.error();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ModernGameDialog(
        title: 'Meaning Lost',
        description: 'Context can be tricky. Review the usage and try again!',
        isSuccess: false,
        isRescueLife: true,
        buttonText: 'GIVE UP',
        onButtonPressed: () {
          Navigator.pop(c);
          context.pop();
        },
        onAdAction: () {
          void restoreLife() {
            context.read<VocabularyBloc>().add(RestoreLife());
            Navigator.pop(c);
          }

          final isPremium =
              context.read<AuthBloc>().state.user?.isPremium ?? false;
          if (isPremium) {
            restoreLife();
          } else {
            di.sl<AdService>().showRewardedAd(
              isPremium: false,
              onUserEarnedReward: (_) => restoreLife(),
              onDismissed: () {},
            );
          }
        },
        adButtonText: 'WATCH AD TO CONTINUE',
      ),
    );
  }
}
