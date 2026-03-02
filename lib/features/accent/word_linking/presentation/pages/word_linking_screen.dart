import 'dart:math' as math;
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
import 'package:voxai_quest/core/presentation/widgets/mesh_gradient_background.dart';
import 'package:voxai_quest/core/presentation/widgets/modern_game_dialog.dart';
import 'package:voxai_quest/core/presentation/widgets/scale_button.dart';
import 'package:voxai_quest/core/presentation/widgets/shimmer_loading.dart';
import 'package:voxai_quest/core/utils/ad_service.dart';
import 'package:voxai_quest/core/utils/haptic_service.dart';
import 'package:voxai_quest/core/utils/injection_container.dart' as di;
import 'package:voxai_quest/core/utils/sound_service.dart';
import 'package:voxai_quest/core/utils/speech_service.dart';
import 'package:voxai_quest/features/accent/presentation/bloc/accent_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';

class WordLinkingScreen extends StatefulWidget {
  final int level;
  const WordLinkingScreen({super.key, required this.level});

  @override
  State<WordLinkingScreen> createState() => _WordLinkingScreenState();
}

class _WordLinkingScreenState extends State<WordLinkingScreen> {
  final _hapticService = di.sl<HapticService>();
  final _soundService = di.sl<SoundService>();
  final _ttsService = di.sl<SpeechService>();
  bool _isPlaying = false;
  bool _showConfetti = false;

  List<String> _words = [];
  final Set<int> _linkedIndices = {};
  bool _hasSubmitted = false;

  late ConfettiController _confettiController;
  AccentLoaded? _lastLoadedState;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    context.read<AccentBloc>().add(
      FetchAccentQuests(gameType: GameSubtype.wordLinking, level: widget.level),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _playAudio(String text) async {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);
    _hapticService.light();
    // Removed _soundService.playClick() to prevent double sound
    await _ttsService.speak(text);
    if (mounted) setState(() => _isPlaying = false);
  }

  void _useHint(AccentLoaded state) {
    if (state.hintUsed || _hasSubmitted) {
      _hapticService.error();
      return;
    }
    _hapticService.selection();
    _soundService.playHint();

    int missingLink = -1;
    for (int i = 0; i < _words.length - 1; i++) {
      if (!_linkedIndices.contains(i)) {
        missingLink = i;
        break;
      }
    }

    if (missingLink != -1) {
      setState(() {
        _linkedIndices.add(missingLink);
      });
      _checkCompletion();
    }

    context.read<AccentBloc>().add(AccentHintUsed());
  }

  void _checkCompletion() {
    if (_linkedIndices.length == _words.length - 1 && !_hasSubmitted) {
      setState(() => _hasSubmitted = true);
      _hapticService.success();
      _soundService.playCorrect();
      context.read<AccentBloc>().add(SubmitAnswer(true));

      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) context.read<AccentBloc>().add(NextQuestion());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = LevelThemeHelper.getTheme(
      'accent',
      level: widget.level,
      isDark: isDark,
    );

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF020617)
          : const Color(0xFFF8FAFC),
      body: BlocConsumer<AccentBloc, AccentState>(
        listener: (context, state) {
          if (state is AccentGameComplete) {
            _confettiController.play();
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
          } else if (state is AccentLoaded) {
            if (_lastLoadedState?.currentQuest != state.currentQuest) {
              _lastLoadedState = state;
              _words = (state.currentQuest.word ?? "")
                  .split(' ')
                  .where((w) => w.isNotEmpty)
                  .toList();
              _linkedIndices.clear();
              _hasSubmitted = false;
            }
          }
        },
        builder: (context, state) {
          if (state is AccentLoading ||
              (state is AccentInitial && _lastLoadedState == null)) {
            return const GameShimmerLoading();
          }

          if (state is AccentError) {
            return QuestUnavailableScreen(
              message: state.message,
              onRetry: () => context.read<AccentBloc>().add(
                FetchAccentQuests(
                  gameType: GameSubtype.wordLinking,
                  level: widget.level,
                ),
              ),
            );
          }

          final displayState = state is AccentLoaded ? state : _lastLoadedState;

          if (displayState != null) {
            return Stack(
              children: [
                MeshGradientBackground(colors: theme.backgroundColors),
                HarmonicWaves(color: theme.primaryColor, height: 100),
                _buildGameUI(context, displayState, isDark, theme),
                if (_showConfetti)
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      colors: const [
                        Colors.amber,
                        Colors.blue,
                        Colors.pink,
                        Colors.orange,
                        Colors.purple,
                      ],
                    ),
                  ),
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

    return Stack(
      children: [
        Column(
          children: [
            _buildHeader(context, state, progress, theme, isDark),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      "WORD LINKING",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      quest.instruction,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ).animate().fadeIn().slideY(begin: 0.1),
                    SizedBox(height: 40.h),

                    // Playback Button
                    ScaleButton(
                      onTap: () => _playAudio(quest.word ?? ""),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.primaryColor.withValues(alpha: 0.9),
                              theme.primaryColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isPlaying)
                              const HarmonicWaves(
                                color: Colors.white,
                                height: 30,
                              ).animate().fadeIn()
                            else
                              Icon(
                                Icons.volume_up_rounded,
                                color: Colors.white,
                                size: 28.r,
                              ),
                            SizedBox(width: 12.w),
                            Text(
                              "LISTEN",
                              style: GoogleFonts.outfit(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms).scale(),

                    if (quest.phonetic != null) ...[
                      SizedBox(height: 20.h),
                      Text(
                        "Pronounced as: ${quest.phonetic}",
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white60 : Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],

                    SizedBox(height: 60.h),

                    // Magnet Connect Play Area
                    if (state.lastAnswerCorrect == null)
                      _buildMagnetPlayArea(isDark, theme)
                    else
                      SizedBox(height: 120.h),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
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
                valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          if (!state.hintUsed) ...[
            _buildHintButton(state, theme.primaryColor),
            SizedBox(width: 12.w),
          ],
          _buildHeartCount(state.livesRemaining),
        ],
      ),
    );
  }

  Widget _buildMagnetPlayArea(bool isDark, ThemeResult theme) {
    if (_words.length <= 1) {
      return Center(
        child: ScaleButton(
          onTap: () {
            setState(() => _hasSubmitted = true);
            context.read<AccentBloc>().add(SubmitAnswer(true));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Text(
              "LINK SOUNDS",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12.w,
      runSpacing: 24.h,
      children: List.generate(_words.length * 2 - 1, (i) {
        if (i.isEven) {
          final wordIndex = i ~/ 2;
          return _buildMagnetWord(
            wordIndex,
            _words[wordIndex],
            isDark,
            theme.primaryColor,
          );
        } else {
          final linkIndex = i ~/ 2;
          final isLinked = _linkedIndices.contains(linkIndex);
          return isLinked
              ? Icon(
                  Icons.link_rounded,
                  color: theme.primaryColor,
                  size: 32.r,
                ).animate().scale(curve: Curves.elasticOut)
              : SizedBox(width: 8.w); // Drop target space
        }
      }),
    );
  }

  Widget _buildMagnetWord(
    int index,
    String word,
    bool isDark,
    Color primaryColor,
  ) {
    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        if (_hasSubmitted) return;
        final draggedIndex = details.data;
        if (draggedIndex == index - 1 || draggedIndex == index + 1) {
          final linkIndex = math.min(index, draggedIndex);
          if (!_linkedIndices.contains(linkIndex)) {
            setState(() {
              _linkedIndices.add(linkIndex);
            });
            _hapticService.success();
            _soundService.playCorrect();
            _checkCompletion();
          }
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return Draggable<int>(
          data: index,
          feedback: Material(
            color: Colors.transparent,
            child: _buildWordCard(word, isDark, primaryColor, isDragging: true),
          ),
          childWhenDragging: Opacity(
            opacity: 0.4,
            child: _buildWordCard(word, isDark, primaryColor),
          ),
          child: _buildWordCard(
            word,
            isDark,
            primaryColor,
            isHovered: isHovered,
          ),
        );
      },
    );
  }

  Widget _buildWordCard(
    String word,
    bool isDark,
    Color primaryColor, {
    bool isDragging = false,
    bool isHovered = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isHovered
            ? primaryColor.withValues(alpha: 0.1)
            : (isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDragging || isHovered
              ? primaryColor
              : (isDark ? Colors.white24 : Colors.black12),
          width: 2,
        ),
        boxShadow: [
          if (isDragging || isHovered)
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Text(
        word,
        style: GoogleFonts.outfit(
          fontSize: 24.sp,
          fontWeight: FontWeight.w800,
          color: isDragging || (isHovered && isDark)
              ? Colors.white
              : (isHovered && !isDark)
              ? Colors.black87
              : (isDark ? Colors.white : Colors.black87),
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

  Widget _buildHintButton(AccentLoaded state, Color primaryColor) {
    bool disabled = state.hintUsed;
    return ScaleButton(
      onTap: disabled ? null : () => _useHint(state),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: disabled
              ? Colors.grey.withValues(alpha: 0.1)
              : primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: disabled
                ? Colors.grey.withValues(alpha: 0.3)
                : primaryColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              disabled
                  ? Icons.lightbulb_outline_rounded
                  : Icons.lightbulb_rounded,
              color: disabled ? Colors.grey : primaryColor,
              size: 20.r,
            ),
            SizedBox(width: 6.w),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                final hintCount = authState.user?.hintCount ?? 0;
                return Text(
                  "$hintCount",
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: disabled ? Colors.grey : primaryColor,
                  ),
                );
              },
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
        title: 'Linking Legend!',
        description:
            'You earned $xp XP and $coins Coins for your smooth transitions!',
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
        title: 'Connection Lost',
        description: 'The sounds were too detached. Try to flow more!',
        isSuccess: false,
        isRescueLife: true,
        buttonText: 'GIVE UP',
        onButtonPressed: () {
          Navigator.pop(c);
          context.pop();
        },
        onAdAction: () {
          void restoreLife() {
            context.read<AccentBloc>().add(RestoreLife());
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
