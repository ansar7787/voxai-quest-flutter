import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/grammar/grammar_quest/domain/usecases/get_grammar_quest_quests.dart';
import 'grammar_quest_event.dart';
import 'grammar_quest_state.dart';

class GrammarQuestBloc extends Bloc<GrammarQuestEvent, GrammarQuestState> {
  final GetGrammarQuestQuests getQuests;

  GrammarQuestBloc({required this.getQuests}) : super(GrammarQuestInitial()) {
    on<FetchGrammarQuestQuests>(_onFetchQuests);
    on<SubmitGrammarQuestAnswer>(_onSubmitAnswer);
    on<NextGrammarQuestQuestion>(_onNextQuestion);
    on<RestoreGrammarQuestLife>(_onRestoreLife);
    on<GrammarQuestHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchGrammarQuestQuests event,
    Emitter<GrammarQuestState> emit,
  ) async {
    emit(GrammarQuestLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(GrammarQuestError(failure.message)),
      (quests) => emit(GrammarQuestLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitGrammarQuestAnswer event,
    Emitter<GrammarQuestState> emit,
  ) {
    final state = this.state;
    if (state is GrammarQuestLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(GrammarQuestGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextGrammarQuestQuestion event,
    Emitter<GrammarQuestState> emit,
  ) {
    final state = this.state;
    if (state is GrammarQuestLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          GrammarQuestGameComplete(
            xpEarned: totalQuests * 10,
            coinsEarned: totalQuests * 5,
          ),
        );
      } else {
        emit(
          state.copyWith(
            currentIndex: nextIndex,
            lastAnswerCorrect: null,
            hintUsed: false,
          ),
        );
      }
    }
  }

  void _onRestoreLife(
    RestoreGrammarQuestLife event,
    Emitter<GrammarQuestState> emit,
  ) {
    emit(GrammarQuestInitial());
  }

  void _onHintUsed(
    GrammarQuestHintUsed event,
    Emitter<GrammarQuestState> emit,
  ) {
    final state = this.state;
    if (state is GrammarQuestLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
