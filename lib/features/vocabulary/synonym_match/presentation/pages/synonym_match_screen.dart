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

class SynonymMatchScreen extends StatefulWidget {
  final int level;
  const SynonymMatchScreen({super.key, required this.level});

  @override
  State<SynonymMatchScreen> createState() => _SynonymMatchScreenState();
}

class _SynonymMatchScreenState extends State<SynonymMatchScreen> {
  final _hapticService = di.sl<HapticService>();
  final _soundService = di.sl<SoundService>();
  int? _selectedOptionIndex;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    context.read<VocabularyBloc>().add(
      FetchVocabularyQuests(
        gameType: GameSubtype.synonymSearch,
        level: widget.level,
      ),
    );
  }

  void _submitAnswer(int index, int correctIndex) {
    if (_selectedOptionIndex != null || _hasSubmitted()) return;
    _hapticService.selection();
    setState(() => _selectedOptionIndex = index);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<VocabularyBloc>().add(SubmitAnswer(index == correctIndex));
      }
    });
  }

  bool _hasSubmitted() {
    final state = context.read<VocabularyBloc>().state;
    return state is VocabularyLoaded && state.lastAnswerCorrect != null;
  }

  void _useHint() {
    _hapticService.selection();
    context.read<VocabularyBloc>().add(VocabularyHintUsed());
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
                  gameType: GameSubtype.synonymSearch,
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      theme.title,
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                        color: theme.primaryColor,
                      ),
                    ).animate().fadeIn(),
                    GlassTile(
                      padding: EdgeInsets.symmetric(vertical: 48.h),
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(32.r),
                      borderColor: theme.primaryColor.withValues(alpha: 0.3),
                      color: isDark
                          ? theme.primaryColor.withValues(alpha: 0.05)
                          : Colors.white.withValues(alpha: 0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              "TARGET WORD",
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
                            quest.word ?? "Word",
                            style: GoogleFonts.outfit(
                              fontSize: 48.sp,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : Colors.black87,
                              letterSpacing: 3,
                              shadows: [
                                Shadow(
                                  color: theme.primaryColor.withValues(
                                    alpha: 0.5,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
                    SizedBox(height: 60.h),
                    ...List.generate(quest.options?.length ?? 0, (index) {
                      final isSelected = _selectedOptionIndex == index;
                      final correctIndex = quest.correctAnswerIndex;

                      Color? cardColor;
                      if (state.lastAnswerCorrect != null && isSelected) {
                        cardColor = (index == correctIndex)
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF43F5E);
                      } else if (state.hintUsed && index == correctIndex) {
                        cardColor = theme.primaryColor.withValues(alpha: 0.15);
                      }

                      return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: ScaleButton(
                              onTap: () =>
                                  _submitAnswer(index, correctIndex ?? 0),
                              child: GlassTile(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 18.h,
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                                color:
                                    cardColor?.withValues(alpha: 0.8) ??
                                    (isDark
                                        ? Colors.white.withValues(alpha: 0.05)
                                        : Colors.black.withValues(alpha: 0.02)),
                                borderColor:
                                    cardColor?.withValues(alpha: 0.3) ??
                                    theme.primaryColor.withValues(alpha: 0.1),
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
                                    if (state.lastAnswerCorrect != null &&
                                        index == correctIndex)
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
                          .fadeIn(delay: (index * 100).ms)
                          .slideY(begin: 0.1);
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (state.lastAnswerCorrect != null)
          ModernGameResultOverlay(
            isCorrect: state.lastAnswerCorrect!,
            title: state.lastAnswerCorrect!
                ? "LEXICAL GENIUS!"
                : "STUDY ROOTS!",
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
        title: 'Synonym Pro!',
        description:
            'You earned $xp XP and $coins Coins for finding the perfect matches!',
        buttonText: 'EXCELLENT',
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
        title: 'Vocabulary Depleted',
        description:
            'Your word power has run out. Review the synonyms and try again!',
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
