import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voxai_quest/features/game/domain/entities/game_quest.dart';
import 'package:voxai_quest/features/reading/domain/entities/reading_quest.dart';
import 'package:voxai_quest/features/writing/domain/entities/writing_quest.dart';
import 'package:voxai_quest/features/speaking/domain/entities/speaking_quest.dart';
import 'package:voxai_quest/features/grammar/domain/entities/grammar_quest.dart';
import 'package:voxai_quest/features/game/presentation/bloc/game_bloc.dart';
import 'package:voxai_quest/features/game/presentation/bloc/game_bloc_event_state.dart';
import 'package:voxai_quest/features/game/presentation/widgets/quest_widgets.dart';

import 'package:voxai_quest/core/utils/injection_container.dart' as di;
import 'package:voxai_quest/core/utils/ad_service.dart';
import 'package:voxai_quest/core/presentation/widgets/shimmer_loading.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = GoRouterState.of(context).uri.queryParameters['category'];
    return BlocProvider(
      create: (context) =>
          di.sl<GameBloc>()..add(StartGame(category: category)),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          _buildMainScaffold(context),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainScaffold(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
        if (state is GameFinished) {
          _confettiController.play();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: _buildAppBarTitle(state),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
            actions: [
              if (state is GameInProgress) _buildHearts(state.lives),
              SizedBox(width: 8.w),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(4.h),
              child: _buildProgressBar(state),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildAppBarTitle(GameState state) {
    if (state is GameInProgress) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Level ${state.level}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (state.streak > 0) ...[
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: state.streak >= 3 ? Colors.orange : Colors.blue[100],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    size: 14.r,
                    color: state.streak >= 3 ? Colors.white : Colors.blue,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${state.streak}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: state.streak >= 3 ? Colors.white : Colors.blue,
                    ),
                  ),
                  if (state.streak >= 3) ...[
                    SizedBox(width: 4.w),
                    Text(
                      'X2',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      );
    }
    return const Text('VoxAI Quest');
  }

  Widget _buildHearts(int lives) {
    return Row(
      children: List.generate(3, (index) {
        return Icon(
          index < lives ? Icons.favorite : Icons.favorite_border,
          color: index < lives
              ? Colors.red
              : Colors.grey.withValues(alpha: 0.5),
          size: 24.r,
        );
      }),
    );
  }

  Widget _buildProgressBar(GameState state) {
    double progress = 0.0;
    if (state is GameInProgress) {
      // Logic: 10 quests per "Goal"? Or just simple progress.
      // Let's say progress is (level % 10) / 10
      progress = ((state.level - 1) % 10) / 10;
    } else if (state is GameFinished) {
      progress = 1.0;
    }
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.grey.withValues(alpha: 0.1),
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
      minHeight: 4.h,
    );
  }

  Widget _buildBody(BuildContext context, GameState state) {
    if (state is GameInitial || state is GameLoading) {
      return const QuestShimmer();
    } else if (state is GameInProgress) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Text(
              state.currentQuest.instruction,
              style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            _buildQuestContent(context, state.currentQuest),
          ],
        ),
      );
    } else if (state is GameFinished) {
      return _buildFinishedUI(context, state.finalScore);
    } else if (state is GameError) {
      return _buildErrorUI(context, state.message);
    }
    return const SizedBox.shrink();
  }

  Widget _buildQuestContent(BuildContext context, GameQuest quest) {
    if (quest is ReadingQuest) {
      return ReadingQuestWidget(
        quest: quest,
        onOptionSelected: (index) =>
            context.read<GameBloc>().add(SubmitAnswer(index)),
      );
    } else if (quest is WritingQuest) {
      return WritingQuestWidget(
        quest: quest,
        onSubmit: (text) => context.read<GameBloc>().add(SubmitAnswer(text)),
      );
    } else if (quest is SpeakingQuest) {
      return SpeakingQuestWidget(
        quest: quest,
        onSubmit: (text) => context.read<GameBloc>().add(SubmitAnswer(text)),
      );
    } else if (quest is GrammarQuest) {
      return GrammarQuestWidget(
        quest: quest,
        onOptionSelected: (index) =>
            context.read<GameBloc>().add(SubmitAnswer(index)),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildFinishedUI(BuildContext context, int score) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.stars_rounded, size: 100.r, color: Colors.amber),
          SizedBox(height: 24.h),
          Text(
            'Amazing Job!',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            'You earned $score coins this session',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey),
          ),
          SizedBox(height: 48.h),
          ElevatedButton(
            onPressed: () {
              final user = context.read<AuthBloc>().state.user;
              if (user != null && !user.isPremium) {
                di.sl<AdService>().showInterstitialAd(
                  isPremium: user.isPremium,
                  onDismissed: () => context.read<GameBloc>().add(NextQuest()),
                );
              } else {
                context.read<GameBloc>().add(NextQuest());
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 56.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: const Text('CONTINUE'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorUI(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.heart_broken_rounded, size: 80.r, color: Colors.red[300]),
          SizedBox(height: 24.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 32.h),
          TextButton(
            onPressed: () => context.read<GameBloc>().add(StartGame()),
            child: const Text('Try Again'),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Go Home', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
