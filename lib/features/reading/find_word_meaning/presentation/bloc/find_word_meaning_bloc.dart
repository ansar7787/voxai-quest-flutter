import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/reading/find_word_meaning/domain/usecases/get_find_word_meaning_quests.dart';
import 'find_word_meaning_event.dart';
import 'find_word_meaning_state.dart';

class FindWordMeaningBloc extends Bloc<FindWordMeaningEvent, FindWordMeaningState> {
  final GetFindWordMeaningQuests getQuests;

  FindWordMeaningBloc({required this.getQuests}) : super(FindWordMeaningInitial()) {
    on<FetchFindWordMeaningQuests>(_onFetchQuests);
    on<SubmitFindWordMeaningAnswer>(_onSubmitAnswer);
    on<NextFindWordMeaningQuestion>(_onNextQuestion);
    on<RestoreFindWordMeaningLife>(_onRestoreLife);
    on<FindWordMeaningHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchFindWordMeaningQuests event,
    Emitter<FindWordMeaningState> emit,
  ) async {
    emit(FindWordMeaningLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(FindWordMeaningError(failure.message)),
      (quests) => emit(FindWordMeaningLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitFindWordMeaningAnswer event,
    Emitter<FindWordMeaningState> emit,
  ) {
    final state = this.state;
    if (state is FindWordMeaningLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(FindWordMeaningGameOver());
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
    NextFindWordMeaningQuestion event,
    Emitter<FindWordMeaningState> emit,
  ) {
    final state = this.state;
    if (state is FindWordMeaningLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(FindWordMeaningGameComplete(
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
    RestoreFindWordMeaningLife event,
    Emitter<FindWordMeaningState> emit,
  ) {
    emit(FindWordMeaningInitial());
  }

  void _onHintUsed(
    FindWordMeaningHintUsed event,
    Emitter<FindWordMeaningState> emit,
  ) {
    final state = this.state;
    if (state is FindWordMeaningLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
