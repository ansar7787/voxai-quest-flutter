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


class OddOneOutScreen extends StatefulWidget {
  final int level;
  const OddOneOutScreen({super.key, required this.level});

  @override
  State<OddOneOutScreen> createState() => _OddOneOutScreenState();
}

class _OddOneOutScreenState extends State<OddOneOutScreen> {
  final _hapticService = di.sl<HapticService>();
  final _soundService = di.sl<SoundService>();
  int? _selectedOptionIndex;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    context.read<VocabularyBloc>().add(
      FetchVocabularyQuests(
        gameType: GameSubtype.topicVocab,
        level: widget.level,
      ),
    );
  }

  void _onOptionSelected(int index) {
    if (_selectedOptionIndex != null) return;
    _hapticService.selection();
    setState(() => _selectedOptionIndex = index);

    final state = context.read<VocabularyBloc>().state;
    if (state is VocabularyLoaded) {
      final isCorrect = index == (state.currentQuest.correctAnswerIndex ?? 0);
      if (isCorrect) {
        _soundService.playCorrect();
        _hapticService.success();
      } else {
        _soundService.playWrong();
        _hapticService.error();
      }
      context.read<VocabularyBloc>().add(SubmitAnswer(isCorrect));
    }
  }

  void _useHint() {
    _hapticService.selection();
    context.read<VocabularyBloc>().add(VocabularyHintUsed());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = LevelThemeHelper.getTheme('vocabulary', level: widget.level);

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
            _selectedOptionIndex = null;
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
                  gameType: GameSubtype.topicVocab,
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
                      "ODD ONE OUT",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      quest.instruction,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Expanded(
                      child: Center(
                        child: Wrap(
                          spacing: 16.w,
                          runSpacing: 16.h,
                          alignment: WrapAlignment.center,
                          children: List.generate(quest.options?.length ?? 0, (
                            index,
                          ) {
                            final isCorrect = index == quest.correctAnswerIndex;
                            final isSelected = _selectedOptionIndex == index;
                            return _buildGridOption(
                              text: quest.options![index],
                              index: index,
                              isSelected: isSelected,
                              isCorrect: isCorrect,
                              showResult: _selectedOptionIndex != null,
                              isDark: isDark,
                              theme: theme,
                            );
                          }),
                        ),
                      ),
                    ),
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
                ? "LOGICAL GENIUS!"
                : "ALMOST HAD IT!",
            subtitle: quest.explanation ?? "Logically consistent!",
            onContinue: () =>
                context.read<VocabularyBloc>().add(NextQuestion()),
            primaryColor: theme.primaryColor,
          ),
        if (_showConfetti) const GameConfetti(),
      ],
    );
  }

  Widget _buildGridOption({
    required String text,
    required int index,
    required bool isSelected,
    required bool isCorrect,
    required bool showResult,
    required bool isDark,
    required ThemeResult theme,
  }) {
    Color? cardColor;
    if (showResult) {
      if (isCorrect) {
        cardColor = const Color(0xFF10B981);
      } else if (isSelected) {
        cardColor = const Color(0xFFF43F5E);
      }
    }

    return ScaleButton(
          onTap: () => _onOptionSelected(index),
          child: GlassTile(
            width: 145.w,
            height: 145.w,
            padding: EdgeInsets.all(18.r),
            color:
                cardColor?.withValues(alpha: 0.9) ??
                (isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.02)),
            borderRadius: BorderRadius.circular(28.r),
            borderColor: showResult
                ? (isCorrect
                      ? Colors.green
                      : (isSelected
                            ? Colors.red
                            : theme.primaryColor.withValues(alpha: 0.1)))
                : (isSelected
                      ? theme.primaryColor
                      : theme.primaryColor.withValues(alpha: 0.2)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: (showResult && (isCorrect || isSelected))
                        ? Colors.white24
                        : theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: GoogleFonts.outfit(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      color: (showResult && (isCorrect || isSelected))
                          ? Colors.white
                          : theme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    color: (showResult && (isCorrect || isSelected))
                        ? Colors.white
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.9)
                              : Colors.black87),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (index * 100).ms)
        .scale(begin: const Offset(0.8, 0.8));
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

  void _showCompletionDialog(BuildContext context, int xp, int coins) {
    _soundService.playLevelComplete();
    _hapticService.success();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ModernGameDialog(
        title: 'Logical Legend!',
        description:
            'You earned $xp XP and $coins Coins for spotting the outliers!',
        buttonText: 'OK',
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
      builder: (c) => ModernGameDialog(
        title: 'Logic Error',
        description: 'Your logic seems to have hit a wall. Try again!',
        buttonText: 'RETRY',
        isSuccess: false,
        onButtonPressed: () => Navigator.pop(c),
        secondaryButtonText: 'QUIT',
        onSecondaryPressed: () {
          Navigator.pop(c);
          context.pop();
        },
      ),
    );
  }
}