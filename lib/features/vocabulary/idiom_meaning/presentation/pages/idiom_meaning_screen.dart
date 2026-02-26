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


class IdiomMeaningScreen extends StatefulWidget {
  final int level;
  const IdiomMeaningScreen({super.key, required this.level});

  @override
  State<IdiomMeaningScreen> createState() => _IdiomMeaningScreenState();
}

class _IdiomMeaningScreenState extends State<IdiomMeaningScreen> {
  final _hapticService = di.sl<HapticService>();
  final _soundService = di.sl<SoundService>();
  int? _selectedOptionIndex;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    context.read<VocabularyBloc>().add(
      FetchVocabularyQuests(gameType: GameSubtype.idioms, level: widget.level),
    );
  }

  void _submitAnswer(int index, int correctIndex) {
    if (_selectedOptionIndex != null) return;
    _hapticService.selection();
    setState(() => _selectedOptionIndex = index);

    bool isCorrect = (index == correctIndex);
    if (isCorrect) {
      _soundService.playCorrect();
    } else {
      _soundService.playWrong();
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<VocabularyBloc>().add(SubmitAnswer(isCorrect));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = LevelThemeHelper.getTheme('vocabulary', level: widget.level, isDark: isDark);

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
                  gameType: GameSubtype.idioms,
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
    final options = quest.options ?? [];

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
                            : Colors.black.withValues(alpha: 0.05),
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
                    SizedBox(height: 10.h),
                    Text(
                      "FIGURE OF SPEECH",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                        color: Colors.deepOrangeAccent,
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
                    SizedBox(height: 40.h),

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
                              "IDIOMATIC EXPRESSION",
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
                            quest.word ?? "Idiom",
                            style: GoogleFonts.outfit(
                              fontSize: 34.sp,
                              fontWeight: FontWeight.w900,
                              color: theme.primaryColor,
                              letterSpacing: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (quest.sentence != null) ...[
                            SizedBox(height: 24.h),
                            Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.black26
                                    : Colors.white.withValues(alpha: 0.26),
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

                    SizedBox(height: 48.h),

                    ...List.generate(
                      options.length,
                      (i) => _buildOption(
                        i,
                        options[i],
                        quest,
                        state,
                        isDark,
                        theme,
                      ),
                    ),

                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (state.lastAnswerCorrect != null)
          ModernGameResultOverlay(
            isCorrect: state.lastAnswerCorrect!,
            title: state.lastAnswerCorrect! ? "IDIOM EXPERT!" : "ALMOST!",
            subtitle: quest.explanation,
            onContinue: () =>
                context.read<VocabularyBloc>().add(NextQuestion()),
            primaryColor: theme.primaryColor,
          ),
        if (_showConfetti) const GameConfetti(),
      ],
    );
  }

  Widget _buildOption(
    int index,
    String text,
    dynamic quest,
    dynamic state,
    bool isDark,
    ThemeResult theme,
  ) {
    final isSelected = _selectedOptionIndex == index;
    final isCorrect = index == quest.correctAnswerIndex;
    final lastResult = state.lastAnswerCorrect;

    Color bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    Color borderColor = theme.primaryColor.withValues(alpha: 0.1);

    if (lastResult != null && isSelected) {
      bgColor = isCorrect ? Colors.green : Colors.red;
      borderColor = bgColor;
    } else if (lastResult != null && isCorrect) {
      borderColor = Colors.green.withValues(alpha: 0.5);
    }

    return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: ScaleButton(
            onTap: () => _submitAnswer(index, quest.correctAnswerIndex!),
            child: GlassTile(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
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
                              : theme.primaryColor.withValues(alpha: 0.1),
                          isSelected
                              ? Colors.white10
                              : theme.primaryColor.withValues(alpha: 0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.white24
                            : theme.primaryColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(64 + (index + 1)),
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: isSelected ? Colors.white : theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 18.w),
                  Expanded(
                    child: Text(
                      text,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : Colors.black87),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  if (lastResult != null && isCorrect)
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
        .fadeIn(delay: Duration(milliseconds: 100 * index))
        .slideX(begin: 0.1);
  }

  Widget _buildHeartCount(int lives) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.pink.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
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
      onTap: used
          ? null
          : () => context.read<VocabularyBloc>().add(VocabularyHintUsed()),
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
        title: 'Idiom Pro!',
        description:
            'You earned $xp XP and $coins Coins for cracking the codes!',
        buttonText: 'AWESOME',
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
        title: 'Expression Expired',
        description:
            'Idioms can be colorful and confusing. Review the meanings and try again!',
        buttonText: 'RETRY',
        isSuccess: false,
        onButtonPressed: () {
          Navigator.pop(c);
          context.read<VocabularyBloc>().add(RestoreLife());
        },
        secondaryButtonText: 'QUIT',
        onSecondaryPressed: () {
          Navigator.pop(c);
          context.pop();
        },
      ),
    );
  }
}