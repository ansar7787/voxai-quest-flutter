import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/grammar/tense_mastery/domain/usecases/get_tense_mastery_quests.dart';
import 'tense_mastery_event.dart';
import 'tense_mastery_state.dart';

class TenseMasteryBloc extends Bloc<TenseMasteryEvent, TenseMasteryState> {
  final GetTenseMasteryQuests getQuests;

  TenseMasteryBloc({required this.getQuests}) : super(TenseMasteryInitial()) {
    on<FetchTenseMasteryQuests>(_onFetchQuests);
    on<SubmitTenseMasteryAnswer>(_onSubmitAnswer);
    on<NextTenseMasteryQuestion>(_onNextQuestion);
    on<RestoreTenseMasteryLife>(_onRestoreLife);
    on<TenseMasteryHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchTenseMasteryQuests event,
    Emitter<TenseMasteryState> emit,
  ) async {
    emit(TenseMasteryLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(TenseMasteryError(failure.message)),
      (quests) => emit(TenseMasteryLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitTenseMasteryAnswer event,
    Emitter<TenseMasteryState> emit,
  ) {
    final state = this.state;
    if (state is TenseMasteryLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(TenseMasteryGameOver());
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
    NextTenseMasteryQuestion event,
    Emitter<TenseMasteryState> emit,
  ) {
    final state = this.state;
    if (state is TenseMasteryLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(TenseMasteryGameComplete(
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
    RestoreTenseMasteryLife event,
    Emitter<TenseMasteryState> emit,
  ) {
    emit(TenseMasteryInitial());
  }

  void _onHintUsed(
    TenseMasteryHintUsed event,
    Emitter<TenseMasteryState> emit,
  ) {
    final state = this.state;
    if (state is TenseMasteryLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
