import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/grammar/word_reorder/domain/usecases/get_word_reorder_quests.dart';
import 'word_reorder_event.dart';
import 'word_reorder_state.dart';

class WordReorderBloc extends Bloc<WordReorderEvent, WordReorderState> {
  final GetWordReorderQuests getQuests;

  WordReorderBloc({required this.getQuests}) : super(WordReorderInitial()) {
    on<FetchWordReorderQuests>(_onFetchQuests);
    on<SubmitWordReorderAnswer>(_onSubmitAnswer);
    on<NextWordReorderQuestion>(_onNextQuestion);
    on<RestoreWordReorderLife>(_onRestoreLife);
    on<WordReorderHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchWordReorderQuests event,
    Emitter<WordReorderState> emit,
  ) async {
    emit(WordReorderLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(WordReorderError(failure.message)),
      (quests) => emit(WordReorderLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitWordReorderAnswer event,
    Emitter<WordReorderState> emit,
  ) {
    final state = this.state;
    if (state is WordReorderLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(WordReorderGameOver());
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
    NextWordReorderQuestion event,
    Emitter<WordReorderState> emit,
  ) {
    final state = this.state;
    if (state is WordReorderLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(WordReorderGameComplete(
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
    RestoreWordReorderLife event,
    Emitter<WordReorderState> emit,
  ) {
    emit(WordReorderInitial());
  }

  void _onHintUsed(
    WordReorderHintUsed event,
    Emitter<WordReorderState> emit,
  ) {
    final state = this.state;
    if (state is WordReorderLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
