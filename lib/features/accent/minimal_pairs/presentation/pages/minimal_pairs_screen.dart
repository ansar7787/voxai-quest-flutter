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
import 'package:voxai_quest/core/utils/ad_service.dart';
import 'package:voxai_quest/core/utils/haptic_service.dart';
import 'package:voxai_quest/core/utils/injection_container.dart' as di;
import 'package:voxai_quest/core/utils/sound_service.dart';
import 'package:voxai_quest/core/utils/speech_service.dart';
import 'package:voxai_quest/features/accent/presentation/bloc/accent_bloc.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';


class MinimalPairsScreen extends StatefulWidget {
  final int level;
  const MinimalPairsScreen({super.key, required this.level});

  @override
  State<MinimalPairsScreen> createState() => _MinimalPairsScreenState();
}

class _MinimalPairsScreenState extends State<MinimalPairsScreen> {
  final _hapticService = di.sl<HapticService>();
  final _soundService = di.sl<SoundService>();
  final _ttsService = di.sl<SpeechService>();
  int? _selectedWordIndex;
  bool _isPlaying = false;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    context.read<AccentBloc>().add(
      FetchAccentQuests(
        gameType: GameSubtype.minimalPairs,
        level: widget.level,
      ),
    );
  }

  void _playAudio(String text) async {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);
    _hapticService.light();
    await _ttsService.speak(text);
    if (mounted) setState(() => _isPlaying = false);
  }

  void _onWordSelected(int index, String targetWord) {
    if (_selectedWordIndex != null) return;
    _hapticService.selection();
    setState(() => _selectedWordIndex = index);

    final state = context.read<AccentBloc>().state;
    if (state is AccentLoaded) {
      // In minimal pairs, the correct word is usually the one stored in 'word' entity field
      // and 'options' contains the pair (e.g. ['Ship', 'Sheep'])
      final isCorrect =
          (state.currentQuest.word?.toLowerCase() == targetWord.toLowerCase());

      if (isCorrect) {
        _soundService.playCorrect();
        _hapticService.success();
      } else {
        _soundService.playWrong();
        _hapticService.error();
      }
      context.read<AccentBloc>().add(SubmitAnswer(isCorrect));
    }
  }

  void _useHint() {
    _hapticService.selection();
    context.read<AccentBloc>().add(AccentHintUsed());
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
          } else if (state is AccentGameOver) {
            _showGameOverDialog(context);
          } else if (state is AccentLoaded && state.lastAnswerCorrect == null) {
            _selectedWordIndex = null;
          }
        },
        builder: (context, state) {
          if (state is AccentLoading || state is AccentInitial) {
            return const GameShimmerLoading();
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
          if (state is AccentError) {
            return QuestUnavailableScreen(
              message: state.message,
              onRetry: () => context.read<AccentBloc>().add(
                
      FetchAccentQuests(
                  gameType: GameSubtype.minimalPairs,
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
    AccentLoaded state,
    bool isDark,
    ThemeResult theme,
  ) {
    final quest = state.currentQuest;
    final progress = (state.currentIndex + 1) / state.quests.length;
    // Mocking options if they don't exist in metadata (they should for minimal pairs)
    final words = quest.options ?? [quest.word ?? "Ship", "Sheep"];

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
                      "MINIMAL PAIRS",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 60.h),

                    Container(
                          width: 160.r,
                          height: 160.r,
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.primaryColor.withValues(alpha: 0.2),
                              width: 2,
                            ),
                          ),
                          child: ScaleButton(
                            onTap: () => _playAudio(quest.word ?? ""),
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (_isPlaying)
                                    const HarmonicWaves(
                                      color: Colors.white,
                                    ).animate().fadeIn(),
                                  Icon(
                                    _isPlaying
                                        ? Icons.graphic_eq_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 64.r,
                                    color: theme.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .animate(target: _isPlaying ? 1 : 0)
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.1, 1.1),
                          duration: 400.ms,
                          curve: Curves.elasticOut,
                        ),

                    SizedBox(height: 40.h),

                    Text(
                      quest.instruction,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),

                    SizedBox(height: 60.h),

                    Row(
                      children: [
                        _buildWordCard(words[0], 0, quest.word!, isDark, theme),
                        SizedBox(width: 20.w),
                        _buildWordCard(words[1], 1, quest.word!, isDark, theme),
                      ],
                    ),

                    const Spacer(),
                    SizedBox(height: 60.h),
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
                ? "PHONETIC PRECISION!"
                : "KEEP LISTENING!",
            subtitle: "Correct Word: ${quest.word ?? ""}",
            onContinue: () => context.read<AccentBloc>().add(NextQuestion()),
            primaryColor: theme.primaryColor,
          ),
        if (_showConfetti) const GameConfetti(),
      ],
    );
  }

  Widget _buildWordCard(
    String word,
    int index,
    String correctWord,
    bool isDark,
    ThemeResult theme,
  ) {
    final isSelected = _selectedWordIndex == index;
    final isCorrect = word.toLowerCase() == correctWord.toLowerCase();
    final showResult = _selectedWordIndex != null;

    Color? cardColor;
    if (showResult) {
      if (isCorrect) {
        cardColor = const Color(0xFF10B981);
      } else if (isSelected) {
        cardColor = const Color(0xFFF43F5E);
      }
    }

    return Expanded(
      child: ScaleButton(
        onTap: () => _onWordSelected(index, word),
        child: GlassTile(
          borderRadius: BorderRadius.circular(32.r),
          padding: EdgeInsets.symmetric(vertical: 40.h),
          color: cardColor?.withValues(alpha: 0.8),
          borderColor: (isSelected && showResult
              ? Colors.white.withValues(alpha: 0.5)
              : (isSelected
                    ? theme.primaryColor
                    : theme.primaryColor.withValues(alpha: 0.1))),
          child: Column(
            children: [
              Text(
                word.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white70 : const Color(0xFF1E293B)),
                  letterSpacing: 1.5,
                ),
              ),
              if (showResult && isCorrect)
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 24.r,
                ).animate().scale(),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 200).ms).slideY(begin: 0.1);
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
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: used
              ? Colors.grey.withValues(alpha: 0.1)
              : primaryColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.lightbulb_rounded,
          color: used ? Colors.grey : primaryColor,
          size: 24.r,
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
        title: 'Phonetic Pro!',
        description: 'You earned $xp XP and $coins Coins for your sharp ears!',
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
      barrierDismissible: false,
      builder: (c) => ModernGameDialog(
        title: 'Frequency Lost',
        description: 'Your listening skills need a quick recharge. Try again!',
        buttonText: 'QUIT',
        isSuccess: false,
        onButtonPressed: () {
          Navigator.pop(c);
          context.pop();
        },
      ),
    );
  }
}