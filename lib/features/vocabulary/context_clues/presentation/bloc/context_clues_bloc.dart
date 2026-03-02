import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/vocabulary/context_clues/domain/usecases/get_context_clues_quests.dart';
import 'context_clues_event.dart';
import 'context_clues_state.dart';

class ContextCluesBloc extends Bloc<ContextCluesEvent, ContextCluesState> {
  final GetContextCluesQuests getQuests;

  ContextCluesBloc({required this.getQuests}) : super(ContextCluesInitial()) {
    on<FetchContextCluesQuests>(_onFetchQuests);
    on<SubmitContextCluesAnswer>(_onSubmitAnswer);
    on<NextContextCluesQuestion>(_onNextQuestion);
    on<RestoreContextCluesLife>(_onRestoreLife);
    on<ContextCluesHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchContextCluesQuests event,
    Emitter<ContextCluesState> emit,
  ) async {
    emit(ContextCluesLoading());
    final result = await getQuests(event.level);
    result.fold((failure) => emit(ContextCluesError(failure.message)), (
      quests,
    ) {
      if (quests.isEmpty) {
        emit(const ContextCluesError("No quests found for this level."));
      } else {
        emit(ContextCluesLoaded(quests: quests));
      }
    });
  }

  void _onSubmitAnswer(
    SubmitContextCluesAnswer event,
    Emitter<ContextCluesState> emit,
  ) {
    final state = this.state;
    if (state is ContextCluesLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(ContextCluesGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextContextCluesQuestion event,
    Emitter<ContextCluesState> emit,
  ) {
    final state = this.state;
    if (state is ContextCluesLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          ContextCluesGameComplete(
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
    RestoreContextCluesLife event,
    Emitter<ContextCluesState> emit,
  ) {
    emit(ContextCluesInitial());
  }

  void _onHintUsed(
    ContextCluesHintUsed event,
    Emitter<ContextCluesState> emit,
  ) {
    final state = this.state;
    if (state is ContextCluesLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
