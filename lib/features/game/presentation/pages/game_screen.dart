import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/game/domain/entities/game_quest.dart';
import 'package:voxai_quest/features/reading/domain/entities/reading_quest.dart';
import 'package:voxai_quest/features/writing/domain/entities/writing_quest.dart';
import 'package:voxai_quest/features/speaking/domain/entities/speaking_quest.dart';
import 'package:voxai_quest/features/game/presentation/bloc/game_bloc.dart';
import 'package:voxai_quest/features/game/presentation/bloc/game_bloc_event_state.dart';

import 'package:voxai_quest/core/utils/injection_container.dart' as di;
import 'package:voxai_quest/features/reading/domain/repositories/reading_repository.dart';
import 'package:voxai_quest/features/writing/domain/repositories/writing_repository.dart';
import 'package:voxai_quest/features/speaking/domain/repositories/speaking_repository.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(
        readingRepository: di.sl<ReadingRepository>(),
        writingRepository: di.sl<WritingRepository>(),
        speakingRepository: di.sl<SpeakingRepository>(),
      )..add(StartGame()),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              if (state is GameInProgress) {
                return Text('Level ${state.level}');
              }
              return const Text('VoxAI Quest');
            },
          ),
          actions: [
            BlocBuilder<GameBloc, GameState>(
              builder: (context, state) {
                if (state is GameInProgress) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: Text('Score: ${state.score}')),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is GameInitial || state is GameLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GameInProgress) {
              return _buildQuestUI(context, state.currentQuest);
            } else if (state is GameFinished) {
              return Center(
                child: Text('Game Finished! Final Score: ${state.finalScore}'),
              );
            } else if (state is GameError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildQuestUI(BuildContext context, GameQuest quest) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            quest.instruction,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (quest is ReadingQuest) ...[
            Text(quest.passage, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            ...quest.options.map(
              (option) => ElevatedButton(
                onPressed: () =>
                    context.read<GameBloc>().add(SubmitAnswer(option)),
                child: Text(option),
              ),
            ),
          ] else if (quest is WritingQuest) ...[
            Text(
              quest.prompt,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type your answer here...',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<GameBloc>().add(SubmitAnswer('answer')),
              child: const Text('Submit'),
            ),
          ] else if (quest is SpeakingQuest) ...[
            const Icon(Icons.mic, size: 64, color: Colors.blue),
            const SizedBox(height: 24),
            Text(
              quest.textToSpeak,
              style: const TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () =>
                  context.read<GameBloc>().add(SubmitAnswer('voice')),
              child: const Text('Start Recording'),
            ),
          ],
        ],
      ),
    );
  }
}
