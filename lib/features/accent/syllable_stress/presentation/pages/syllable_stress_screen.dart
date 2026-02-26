import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/core/presentation/pages/quest_unavailable_screen.dart';
import 'package:voxai_quest/core/presentation/themes/level_theme_helper.dart';
import 'package:voxai_quest/core/presentation/widgets/accent/harmonic_waves.dart';
import 'package:voxai_quest/core/presentation/widgets/game_confetti.dart';
import 'package:voxai_quest/core/presentation/widgets/glass_tile.dart';
import 'package:voxai_quest/core/presentation/widgets/mesh_gradient_background.dart';
import 'package:voxai_quest/core/presentation/widgets/modern_game_dialog.dart';
import 'package:voxai_quest/core/presentation/widgets/modern_game_result_overlay.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/core/presentation/widgets/shimmer_loading.dart';
import 'package:voxai_quest/core/utils/haptic_service.dart';
import 'package:voxai_quest/core/utils/injection_container.dart' as di;
import 'package:voxai_quest/core/utils/sound_service.dart';
import 'package:voxai_quest/features/accent/domain/entities/accent_quest.dart';
import 'package:voxai_quest/features/accent/presentation/bloc/accent_bloc.dart';

class SyllableStressScreen extends StatefulWidget {
  final int level;
  const SyllableStressScreen({super.key, required this.level});

  @override
  State<SyllableStressScreen> createState() => _SyllableStressScreenState();
}

class _SyllableStressScreenState extends State<SyllableStressScreen> {
  final _hapticService = di.sl<HapticService>();
  final _soundService = di.sl<SoundService>();
  int? _selectedSyllableIndex;
  bool _hasSubmitted = false;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    context.read<AccentBloc>().add(
      FetchAccentQuests(
        gameType: GameSubtype.syllableStress,
        level: widget.level,
      ),
    );
  }

  void _onSyllableTap(int index) {
    if (_hasSubmitted) return;
    _hapticService.selection();
    setState(() {
      _selectedSyllableIndex = index;
    });
  }

  void _submitAnswer(AccentQuest quest) {
    if (_selectedSyllableIndex == null || _hasSubmitted) return;
    setState(() => _hasSubmitted = true);

    final isCorrect = _selectedSyllableIndex == quest.correctAnswerIndex;
    if (isCorrect) {
      _hapticService.success();
      _soundService.playCorrect();
    } else {
      _hapticService.error();
      _soundService.playWrong();
    }
    context.read<AccentBloc>().add(SubmitAnswer(isCorrect));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = LevelThemeHelper.getTheme('accent', level: widget.level, isDark: isDark);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocConsumer<AccentBloc, AccentState>(
        listener: (context, state) {
          if (state is AccentGameComplete) {
            setState(() => _showConfetti = true);
            _showCompletionDialog(context, state.xpEarned, state.coinsEarned);
          } else if (state is AccentGameOver) {
            _showGameOverDialog(context);
          } else if (state is AccentLoaded && state.lastAnswerCorrect == null) {
            setState(() {
              _selectedSyllableIndex = null;
              _hasSubmitted = false;
            });
          }
        },
        builder: (context, state) {
          if (state is AccentLoading || state is AccentInitial) {
            return const GameShimmerLoading();
          }

          if (state is AccentError) {
            return QuestUnavailableScreen(
              message: state.message,
              onRetry: () => context.read<AccentBloc>().add(
                
      FetchAccentQuests(
                  gameType: GameSubtype.syllableStress,
                  level: widget.level,
                ),
              ),
            );
          }
          if (state is AccentLoaded) {

            return Stack(
              children: [
                MeshGradientBackground(colors: theme.backgroundColors),
                HarmonicWaves(color: theme.primaryColor),
                _buildGameUI(context, state, isDark, theme),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGameUI(
    BuildContext context,
    AccentLoaded state,
    bool isDark,
    ThemeResult theme,
  ) {
    final quest = state.currentQuest;
    final progress = (state.currentIndex + 1) / state.quests.length;
    final syllables = quest.options ?? [];

    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              _buildHeader(context, state, progress, theme, isDark),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        "SYLLABLE STRESS",
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                          color: theme.primaryColor,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        quest.instruction,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1E293B),
                        ),
                      ).animate().fadeIn().slideY(begin: 0.1),
                      SizedBox(height: 60.h),
                      _buildWordDisplay(quest.word ?? '', theme, isDark),
                      SizedBox(height: 60.h),
                      _buildSyllablesList(syllables, theme, isDark),
                      SizedBox(height: 60.h),
                    ],
                  ),
                ),
              ),
              _buildSubmitButton(quest, theme),
              SizedBox(height: 40.h),
            ],
          ),
        ),
        if (state.lastAnswerCorrect != null)
          ModernGameResultOverlay(
            isCorrect: state.lastAnswerCorrect!,
            title: state.lastAnswerCorrect!
                ? "RHYTHMIC GENIUS!"
                : "STRESS POINT!",
            subtitle: "Language has its own beat.",
            onContinue: () => context.read<AccentBloc>().add(NextQuestion()),
            primaryColor: theme.primaryColor,
          ),
        if (_showConfetti) const GameConfetti(),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AccentLoaded state,
    double progress,
    ThemeResult theme,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 10.h),
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
                backgroundColor: isDark ? Colors.white10 : Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          _buildHeartCount(state.livesRemaining),
        ],
      ),
    );
  }

  Widget _buildWordDisplay(String word, ThemeResult theme, bool isDark) {
    return GlassTile(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
      borderRadius: BorderRadius.circular(40.r),
      borderColor: theme.primaryColor.withValues(alpha: 0.3),
      child: Text(
        word.toUpperCase(),
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(
          fontSize: 36.sp,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : Colors.black87,
          letterSpacing: 6,
        ),
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildSyllablesList(
    List<String> syllables,
    ThemeResult theme,
    bool isDark,
  ) {
    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      alignment: WrapAlignment.center,
      children: List.generate(
        syllables.length,
        (index) => _buildSyllableChip(syllables[index], index, theme, isDark),
      ),
    );
  }

  Widget _buildSyllableChip(
    String syllable,
    int index,
    ThemeResult theme,
    bool isDark,
  ) {
    final isSelected = _selectedSyllableIndex == index;

    return ScaleButton(
          onTap: () => _onSyllableTap(index),
          child: GlassTile(
            glassOpacity: isSelected ? 0.3 : 0.1,
            borderColor: isSelected ? theme.primaryColor : Colors.white24,
            color: isSelected
                ? theme.primaryColor.withValues(alpha: 0.2)
                : null,
            borderRadius: BorderRadius.circular(24.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    syllable.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.black54),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      margin: EdgeInsets.only(top: 8.h),
                      height: 4.h,
                      width: 24.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ).animate().scaleX(),
                ],
              ),
            ),
          ),
        )
        .animate(target: isSelected ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1));
  }

  Widget _buildSubmitButton(AccentQuest quest, ThemeResult theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: ScaleButton(
        onTap: _selectedSyllableIndex == null || _hasSubmitted
            ? null
            : () => _submitAnswer(quest),
        child: Container(
          width: double.infinity,
          height: 64.h,
          decoration: BoxDecoration(
            color: _selectedSyllableIndex == null
                ? Colors.grey.withValues(alpha: 0.2)
                : theme.primaryColor,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              if (_selectedSyllableIndex != null)
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: Center(
            child: Text(
              "VERIFY STRESS",
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: _selectedSyllableIndex == null
                    ? Colors.grey
                    : Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
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

  

  void _showCompletionDialog(BuildContext context, int xp, int coins) {
    _hapticService.success();
    _soundService.playLevelComplete();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ModernGameDialog(
        title: "STRESS MASTER!",
        description:
            "You've got the rhythm of a native speaker! Earned $xp XP and $coins coins.",
        buttonText: "CONTINUE",
        onButtonPressed: () {
          Navigator.pop(context);
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
      builder: (context) => ModernGameDialog(
        title: "OUT OF STEP",
        description: "Don't lose your pulse. Try again to find the stress!",
        buttonText: "RETRY",
        isSuccess: false,
        onButtonPressed: () {
          Navigator.pop(context);
          context.read<AccentBloc>().add(RestoreLife());
        },
        secondaryButtonText: "EXIT",
        onSecondaryPressed: () {
          Navigator.pop(context);
          context.pop();
        },
      ),
    );
  }
}