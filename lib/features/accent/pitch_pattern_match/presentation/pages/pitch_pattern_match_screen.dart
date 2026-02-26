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
import 'package:voxai_quest/core/presentation/widgets/speaking/sonic_mic_button.dart';
import 'package:voxai_quest/core/utils/ad_service.dart';
import 'package:voxai_quest/core/utils/haptic_service.dart';
import 'package:voxai_quest/core/utils/injection_container.dart' as di;
import 'package:voxai_quest/core/utils/sound_service.dart';
import 'package:voxai_quest/core/utils/speech_service.dart';
import 'package:voxai_quest/features/accent/presentation/bloc/accent_bloc.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';


class PitchPatternMatchScreen extends StatefulWidget {
  final int level;
  const PitchPatternMatchScreen({super.key, required this.level});

  @override
  State<PitchPatternMatchScreen> createState() =>
      _PitchPatternMatchScreenState();
}

class _PitchPatternMatchScreenState extends State<PitchPatternMatchScreen> {
  final _speechService = di.sl<SpeechService>();
  final _hapticService = di.sl<HapticService>();
  final _soundService = di.sl<SoundService>();
  bool _isListening = false;
  bool _isPlaying = false;
  String _recognizedText = '';
  bool _hasAnalyzed = false;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _speechService.initializeStt();
    context.read<AccentBloc>().add(
      FetchAccentQuests(
        gameType: GameSubtype.pitchPatternMatch,
        level: widget.level,
      ),
    );
  }

  void _playAudio(String text) async {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);
    _hapticService.light();
    await _speechService.speak(text);
    if (mounted) setState(() => _isPlaying = false);
  }

  void _startListening() {
    _hapticService.success();
    setState(() {
      _isListening = true;
      _recognizedText = '';
      _hasAnalyzed = false;
    });

    _speechService.listen(
      onResult: (result) {
        setState(() {
          _recognizedText = result;
        });
      },
      onDone: () {
        if (mounted) {
          setState(() => _isListening = false);
          _analyzeSpeech();
        }
      },
    );
  }

  void _stopListening() async {
    _hapticService.light();
    await _speechService.stop();
    setState(() => _isListening = false);
    _analyzeSpeech();
  }

  void _analyzeSpeech() {
    if (_hasAnalyzed || _recognizedText.isEmpty) return;
    _hasAnalyzed = true;

    final state = context.read<AccentBloc>().state;
    if (state is! AccentLoaded) return;

    final targetText = (state.currentQuest.word ?? "").toLowerCase().replaceAll(
      RegExp(r'[^\w\s]'),
      '',
    );
    final utteredText = _recognizedText.toLowerCase().replaceAll(
      RegExp(r'[^\w\s]'),
      '',
    );

    // Pitch pattern matching doesn't strictly need 100% word match if the intonation is the focus,
    // but here we use 75% as a proxy for engagement.
    bool isCorrect =
        utteredText == targetText ||
        utteredText.contains(targetText) ||
        (targetText.contains(utteredText) &&
            utteredText.length > targetText.length * 0.75);

    context.read<AccentBloc>().add(SubmitAnswer(isCorrect));
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
                  gameType: GameSubtype.pitchPatternMatch,
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
                    SizedBox(height: 20.h),
                    Text(
                      "PITCH PATTERN MATCH",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Follow the melody",
                      style: GoogleFonts.outfit(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    SizedBox(height: 40.h),

                    // Pitch Visualizer Card
                    GlassTile(
                      padding: EdgeInsets.all(32.r),
                      borderRadius: BorderRadius.circular(40.r),
                      borderColor: theme.primaryColor.withValues(alpha: 0.3),
                      child: Column(
                        children: [
                          _buildPitchCurve(theme.primaryColor),
                          SizedBox(height: 32.h),
                          Text(
                            quest.word ?? "Musicality",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          ScaleButton(
                            onTap: () => _playAudio(quest.word ?? ""),
                            child: Container(
                              padding: EdgeInsets.all(20.r),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isPlaying
                                    ? Icons.waves_rounded
                                    : Icons.play_arrow_rounded,
                                color: theme.primaryColor,
                                size: 32.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 400.ms).scale(),

                    SizedBox(height: 48.h),
                    if (_recognizedText.isNotEmpty)
                      GlassTile(
                        padding: EdgeInsets.all(20.r),
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        child: Text(
                          _recognizedText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: theme.primaryColor,
                          ),
                        ),
                      ).animate().fadeIn(),
                    SizedBox(height: 40.h),
                    if (state.lastAnswerCorrect == null)
                      SonicMicButton(
                        isListening: _isListening,
                        onStart: _startListening,
                        onStop: _stopListening,
                        primaryColor: theme.primaryColor,
                      ),
                    SizedBox(height: 16.h),
                    Text(
                      _isListening ? "RECORDING..." : "PRESS & HOLD TO SPEAK",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white38 : Colors.black38,
                        letterSpacing: 1,
                      ),
                    ),
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
                ? "PITCH PERFECT!"
                : "STAY IN TUNE!",
            subtitle: "The melody of language.",
            onContinue: () => context.read<AccentBloc>().add(NextQuestion()),
            primaryColor: theme.primaryColor,
          ),
        if (_showConfetti) const GameConfetti(),
      ],
    );
  }

  Widget _buildPitchCurve(Color color) {
    return SizedBox(
      height: 60.h,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(12, (index) {
          final height = (index % 3 + 1) * 15.0;
          return Container(
                width: 8.w,
                height: height.h,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.3 + (index * 0.05)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scaleY(
                begin: 0.5,
                end: 1.5,
                duration: Duration(milliseconds: 500 + (index * 100)),
              );
        }),
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
        title: 'Pitch Prodigy!',
        description:
            'You earned $xp XP and $coins Coins for your melodic accuracy!',
        buttonText: 'HARMONIOUS',
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
        title: 'Off Key',
        description: 'The pitch was a bit flat. Try to sing the words!',
        buttonText: 'RETRY',
        isSuccess: false,
        onButtonPressed: () {
          Navigator.pop(c);
          context.read<AccentBloc>().add(RestoreLife());
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