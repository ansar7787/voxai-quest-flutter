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
import 'package:voxai_quest/features/accent/domain/entities/accent_quest.dart';
import 'package:voxai_quest/features/accent/presentation/bloc/accent_bloc.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:confetti/confetti.dart';

class ConsonantClarityScreen extends StatefulWidget {
  final int level;
  const ConsonantClarityScreen({super.key, required this.level});

  @override
  State<ConsonantClarityScreen> createState() => _ConsonantClarityScreenState();
}

class _ConsonantClarityScreenState extends State<ConsonantClarityScreen> {
  final _hapticService = di.sl<HapticService>();
  final _soundService = di.sl<SoundService>();
  final _ttsService = di.sl<SpeechService>();
  bool _isPlaying = false;
  bool _showConfetti = false;

  late ConfettiController _confettiController;
  AccentLoaded? _lastLoadedState;
  bool _hasSubmitted = false;
  int? _selectedOptionIndex;
  bool _isDragging = false;
  final List<int> _eliminatedIndices = [];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    context.read<AccentBloc>().add(
      FetchAccentQuests(
        gameType: GameSubtype.consonantClarity,
        level: widget.level,
      ),
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

  void _checkAnswer(int index, AccentQuest quest) {
    if (_hasSubmitted || _eliminatedIndices.contains(index)) return;

    setState(() {
      _selectedOptionIndex = index;
    });

    bool isCorrect = false;
    if (quest.correctAnswerIndex != null) {
      isCorrect = (index == quest.correctAnswerIndex);
    } else if (quest.correctAnswer != null && quest.options != null) {
      isCorrect = (quest.options![index] == quest.correctAnswer);
    } else {
      isCorrect = (index == 0); // Fallback
    }

    if (isCorrect) {
      setState(() => _hasSubmitted = true);
      _hapticService.success();
      _soundService.playCorrect();
      context.read<AccentBloc>().add(SubmitAnswer(true));

      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) context.read<AccentBloc>().add(NextQuestion());
      });
    } else {
      _hapticService.error();
      _soundService.playWrong();
      setState(() => _hasSubmitted = false);
      context.read<AccentBloc>().add(SubmitAnswer(false));
    }
  }

  void _useHint(AccentLoaded state, AccentQuest quest) {
    if (state.hintUsed) {
      _hapticService.error();
      return;
    }
    _hapticService.selection();
    _soundService.playHint();

    final options = quest.options ?? ['P', 'B'];

    int wrongIndex = -1;
    for (int i = 0; i < options.length; i++) {
      bool isMatch = false;
      if (quest.correctAnswerIndex != null) {
        isMatch = (i == quest.correctAnswerIndex);
      } else if (quest.correctAnswer != null) {
        isMatch = (options[i] == quest.correctAnswer);
      } else {
        isMatch = (i == 0);
      }

      if (!isMatch && !_eliminatedIndices.contains(i)) {
        wrongIndex = i;
        break;
      }
    }

    if (wrongIndex != -1) {
      setState(() => _eliminatedIndices.add(wrongIndex));
    }
    context.read<AccentBloc>().add(AccentHintUsed());
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
            _lastLoadedState = state;
            if (state.lastAnswerCorrect == null) {
              setState(() {
                _hasSubmitted = false;
                _selectedOptionIndex = null;
                _isDragging = false;
                _eliminatedIndices.clear();
              });
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
                  gameType: GameSubtype.consonantClarity,
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
                  if (!state.hintUsed) ...[
                    _buildHintButton(state, theme.primaryColor, quest),
                    SizedBox(width: 12.w),
                  ],
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
                      "CONSONANT CLARITY",
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
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.9)
                            : Colors.black87,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    SizedBox(height: 40.h),

                    // Standard Playback Button
                    if (quest.audioUrl != null || quest.word != null)
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
                                color: theme.primaryColor.withValues(
                                  alpha: 0.3,
                                ),
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

                    SizedBox(height: 40.h),

                    // Target Gates and Draggable
                    if (state.lastAnswerCorrect == null)
                      _buildSparkGates(quest, isDark, theme)
                    else
                      SizedBox(height: 200.h),

                    SizedBox(height: 60.h),
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

  Widget _buildSparkGates(AccentQuest quest, bool isDark, ThemeResult theme) {
    final options = quest.options ?? ['P', 'B'];
    final baseWord = quest.word ?? "...";

    return Column(
      children: [
        // Gates Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(options.length, (index) {
            final option = options[index];
            final isSelected = _selectedOptionIndex == index;

            bool isCorrect = false;
            if (_hasSubmitted) {
              if (quest.correctAnswerIndex != null) {
                isCorrect = index == quest.correctAnswerIndex;
              } else if (quest.correctAnswer != null) {
                isCorrect = options[index] == quest.correctAnswer;
              } else {
                isCorrect = index == 0;
              }
            }

            final isEliminated = _eliminatedIndices.contains(index);

            Color gateColor = theme.primaryColor;
            if (isEliminated) {
              gateColor = isDark ? Colors.white12 : Colors.black12;
            } else if (_hasSubmitted) {
              if (isCorrect) {
                gateColor = Colors.greenAccent;
              } else if (isSelected) {
                gateColor = Colors.redAccent;
              } else {
                gateColor = Colors.grey.withValues(alpha: 0.3);
              }
            }

            return DragTarget<String>(
              onWillAcceptWithDetails: (details) {
                _hapticService.light();
                return true;
              },
              onAcceptWithDetails: (details) {
                if (!_hasSubmitted) {
                  _checkAnswer(index, quest);
                }
              },
              builder: (context, candidateData, rejectedData) {
                final isHovered = candidateData.isNotEmpty && !_hasSubmitted;

                return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 100.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: isEliminated
                            ? Colors.transparent
                            : (isHovered || isSelected)
                            ? gateColor.withValues(alpha: 0.2)
                            : gateColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isEliminated
                              ? Colors.transparent
                              : isHovered
                              ? gateColor
                              : gateColor.withValues(alpha: 0.3),
                          width: isHovered ? 4 : 2,
                        ),
                        boxShadow: [
                          if (isHovered ||
                              isSelected ||
                              (isCorrect && _hasSubmitted))
                            BoxShadow(
                              color: gateColor.withValues(alpha: 0.4),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            (isCorrect && _hasSubmitted)
                                ? Icons.check_circle_rounded
                                : (isSelected && _hasSubmitted)
                                ? Icons.cancel_rounded
                                : Icons.flash_on_rounded,
                            color: gateColor,
                            size: 32.r,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            option,
                            style: GoogleFonts.outfit(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: isEliminated
                                  ? (isDark ? Colors.white24 : Colors.black26)
                                  : (isHovered || isSelected) && isDark
                                  ? gateColor
                                  : (isHovered || isSelected) && !isDark
                                  ? Colors.black87
                                  : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate(target: isHovered ? 1 : 0)
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.05, 1.05),
                    );
              },
            );
          }),
        ),

        SizedBox(height: 60.h),

        // Draggable Word Block
        if (!_hasSubmitted)
          Draggable<String>(
            data: "word",
            onDragStarted: () {
              setState(() => _isDragging = true);
              _hapticService.selection();
            },
            onDragEnd: (details) {
              setState(() => _isDragging = false);
            },
            feedback: _buildDraggableBlock(
              baseWord,
              theme.primaryColor,
              isDark,
              true,
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: _buildDraggableBlock(
                baseWord,
                theme.primaryColor,
                isDark,
                false,
              ),
            ),
            child:
                _buildDraggableBlock(
                      baseWord,
                      theme.primaryColor,
                      isDark,
                      false,
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: 3.seconds,
                      delay: 1.seconds,
                      color: theme.primaryColor.withValues(alpha: 0.3),
                    ),
          ),

        if (!_isDragging && !_hasSubmitted) ...[
          SizedBox(height: 20.h),
          Text(
            "DRAG TO MATCH THE SOUND",
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white38 : Colors.black38,
              letterSpacing: 2,
            ),
          ).animate().fadeIn(delay: 800.ms),
        ],
      ],
    );
  }

  Widget _buildDraggableBlock(
    String word,
    Color primaryColor,
    bool isDark,
    bool isDragging,
  ) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: isDragging ? 0.6 : 0.3),
              blurRadius: isDragging ? 30 : 15,
              spreadRadius: isDragging ? 5 : 0,
              offset: isDragging ? Offset(0, 10) : Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          word.replaceAll('_', ' '),
          style: GoogleFonts.outfit(
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2,
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

  Widget _buildHintButton(
    AccentLoaded state,
    Color primaryColor,
    AccentQuest quest,
  ) {
    bool disabled = state.hintUsed;
    return ScaleButton(
      onTap: disabled ? null : () => _useHint(state, quest),
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
        title: 'Articulation Ace!',
        description:
            'You earned 5 XP and 10 Coins for your clear articulation!',
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
        title: 'Sound Muffled',
        description: 'The consonants were lost in the static. Try again!',
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
