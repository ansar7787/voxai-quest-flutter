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
import 'package:voxai_quest/core/presentation/widgets/listening/sound_wave.dart';
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


class IntonationMimicScreen extends StatefulWidget {
  final int level;
  const IntonationMimicScreen({super.key, required this.level});

  @override
  State<IntonationMimicScreen> createState() => _IntonationMimicScreenState();
}

class _IntonationMimicScreenState extends State<IntonationMimicScreen> {
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
        gameType: GameSubtype.intonationMimic,
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

    // Intonation mimic allows 70% similarity for text, assuming the focus is on the "vibe"
    bool isCorrect =
        utteredText == targetText ||
        utteredText.contains(targetText) ||
        (targetText.contains(utteredText) &&
            utteredText.length > targetText.length * 0.7);

    context.read<AccentBloc>().add(SubmitAnswer(isCorrect));
  }

  void _useHint() {
    _hapticService.selection();
    context.read<AccentBloc>().add(AccentHintUsed());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
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
            final theme = LevelThemeHelper.getTheme(
              'accent',
              level: widget.level,
            );
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
                  gameType: GameSubtype.intonationMimic,
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
                      theme.title,
                      style: GoogleFonts.outfit(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Main Phrase Card
                    GlassTile(
                      padding: EdgeInsets.all(40.r),
                      borderRadius: BorderRadius.circular(40.r),
                      borderColor: theme.primaryColor.withValues(alpha: 0.3),
                      color: isDark
                          ? theme.primaryColor.withValues(alpha: 0.05)
                          : Colors.white.withValues(alpha: 0.5),
                      child: Column(
                        children: [
                          ScaleButton(
                            onTap: () => _playAudio(quest.word ?? ""),
                            child: Container(
                              width: 80.r,
                              height: 80.r,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.primaryColor.withValues(alpha: 0.2),
                                    theme.primaryColor.withValues(alpha: 0.05),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.primaryColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 2,
                                ),
                              ),
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
                                          ? Icons.volume_up_rounded
                                          : Icons.play_arrow_rounded,
                                      color: theme.primaryColor,
                                      size: 32.r,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 32.h),
                          Text(
                            quest.word ?? "Perfect practice makes perfect.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w900,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
                              letterSpacing: 1.2,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),

                    SizedBox(height: 40.h),

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

                    // Waveform Mock
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(12, (index) {
                        return Container(
                              width: 6.w,
                              height:
                                  (index % 3 == 0
                                          ? 40
                                          : index % 2 == 0
                                          ? 25
                                          : 15)
                                      .h,
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              decoration: BoxDecoration(
                                color: _isListening
                                    ? theme.primaryColor
                                    : theme.primaryColor.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            )
                            .animate(target: _isListening ? 1 : 0)
                            .scaleY(
                              begin: 0.5,
                              end: 1.5,
                              duration: (500 + index * 100).ms,
                              curve: Curves.easeInOut,
                            );
                      }),
                    ),

                    SizedBox(height: 40.h),

                    if (_recognizedText.isNotEmpty)
                      GlassTile(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 16.h,
                        ),
                        borderRadius: BorderRadius.circular(24.r),
                        borderColor: theme.primaryColor.withValues(alpha: 0.3),
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        child: Text(
                          _recognizedText.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            color: isDark ? Colors.white : theme.primaryColor,
                          ),
                        ),
                      ).animate().fadeIn().slideY(begin: 0.1),

                    SizedBox(height: 40.h),

                    if (state.lastAnswerCorrect == null)
                      _buildMicButton(_isListening, theme.primaryColor),

                    SizedBox(height: 40.h),
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
                ? "MELODIC MATCH!"
                : "FEEL THE RHYTHM!",
            subtitle: "Keep practicing: ${quest.word ?? ""}",
            onContinue: () => context.read<AccentBloc>().add(NextQuestion()),
            primaryColor: theme.primaryColor,
          ),
        if (_showConfetti) const GameConfetti(),
      ],
    );
  }

  Widget _buildMicButton(bool isListening, Color primaryColor) {
    return ScaleButton(
          onTap: isListening ? _stopListening : _startListening,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isListening)
                const SoundWave(color: Colors.redAccent).animate().fadeIn(),
              Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isListening
                        ? [Colors.redAccent, Colors.red.shade900]
                        : [primaryColor, primaryColor.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isListening ? Colors.redAccent : primaryColor)
                          .withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  isListening ? Icons.stop_rounded : Icons.mic_rounded,
                  color: Colors.white,
                  size: 48.r,
                ),
              ),
            ],
          ),
        )
        .animate(target: isListening ? 1 : 0)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.2, 1.2),
          duration: 500.ms,
          curve: Curves.easeInOut,
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

  void _showCompletionDialog(BuildContext context, int xp, int coins) {
    _soundService.playLevelComplete();
    _hapticService.success();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => ModernGameDialog(
        title: 'Rhythm Master!',
        description:
            'You earned $xp XP and $coins Coins for your perfect intonation!',
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
        title: 'Silence Reigned',
        description: 'Take a breath and try to feel the melody!',
        buttonText: 'TRY AGAIN',
        isSuccess: false,
        onButtonPressed: () {
          Navigator.pop(c);
          context.read<AccentBloc>().add(RestoreLife());
        },
        secondaryButtonText: 'EXIT',
        onSecondaryPressed: () {
          Navigator.pop(c);
          context.pop();
        },
      ),
    );
  }
}