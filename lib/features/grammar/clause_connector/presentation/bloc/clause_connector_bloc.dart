import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/grammar/clause_connector/domain/usecases/get_clause_connector_quests.dart';
import 'clause_connector_event.dart';
import 'clause_connector_state.dart';

class ClauseConnectorBloc extends Bloc<ClauseConnectorEvent, ClauseConnectorState> {
  final GetClauseConnectorQuests getQuests;

  ClauseConnectorBloc({required this.getQuests}) : super(ClauseConnectorInitial()) {
    on<FetchClauseConnectorQuests>(_onFetchQuests);
    on<SubmitClauseConnectorAnswer>(_onSubmitAnswer);
    on<NextClauseConnectorQuestion>(_onNextQuestion);
    on<RestoreClauseConnectorLife>(_onRestoreLife);
    on<ClauseConnectorHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchClauseConnectorQuests event,
    Emitter<ClauseConnectorState> emit,
  ) async {
    emit(ClauseConnectorLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(ClauseConnectorError(failure.message)),
      (quests) => emit(ClauseConnectorLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitClauseConnectorAnswer event,
    Emitter<ClauseConnectorState> emit,
  ) {
    final state = this.state;
    if (state is ClauseConnectorLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(ClauseConnectorGameOver());
        } else {
          emit(state.copyWith(
            livesRemaining: newLives,
            lastAnswerCorrect: false,
          ));
        }
      }
    }
  }

  void _onNextQuestion(
    NextClauseConnectorQuestion event,
    Emitter<ClauseConnectorState> emit,
  ) {
    final state = this.state;
    if (state is ClauseConnectorLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(ClauseConnectorGameComplete(
          xpEarned: totalQuests * 10,
          coinsEarned: totalQuests * 5,
        ));
      } else {
        emit(state.copyWith(
          currentIndex: nextIndex,
          lastAnswerCorrect: null,
          hintUsed: false,
        ));
      }
    }
  }

  void _onRestoreLife(
    RestoreClauseConnectorLife event,
    Emitter<ClauseConnectorState> emit,
  ) {
    emit(ClauseConnectorInitial());
  }

  void _onHintUsed(
    ClauseConnectorHintUsed event,
    Emitter<ClauseConnectorState> emit,
  ) {
    final state = this.state;
    if (state is ClauseConnectorLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
