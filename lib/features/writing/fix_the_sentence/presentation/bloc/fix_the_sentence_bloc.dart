import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/writing/fix_the_sentence/domain/usecases/get_fix_the_sentence_quests.dart';
import 'fix_the_sentence_event.dart';
import 'fix_the_sentence_state.dart';

class FixTheSentenceBloc
    extends Bloc<FixTheSentenceEvent, FixTheSentenceState> {
  final GetFixTheSentenceQuests getQuests;

  FixTheSentenceBloc({required this.getQuests})
    : super(FixTheSentenceInitial()) {
    on<FetchFixTheSentenceQuests>(_onFetchQuests);
    on<SubmitFixTheSentenceAnswer>(_onSubmitAnswer);
    on<NextFixTheSentenceQuestion>(_onNextQuestion);
    on<RestoreFixTheSentenceLife>(_onRestoreLife);
    on<FixTheSentenceHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchFixTheSentenceQuests event,
    Emitter<FixTheSentenceState> emit,
  ) async {
    emit(FixTheSentenceLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(FixTheSentenceError(failure.message)),
      (quests) => emit(FixTheSentenceLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitFixTheSentenceAnswer event,
    Emitter<FixTheSentenceState> emit,
  ) {
    final state = this.state;
    if (state is FixTheSentenceLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(FixTheSentenceGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextFixTheSentenceQuestion event,
    Emitter<FixTheSentenceState> emit,
  ) {
    final state = this.state;
    if (state is FixTheSentenceLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          FixTheSentenceGameComplete(
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
    RestoreFixTheSentenceLife event,
    Emitter<FixTheSentenceState> emit,
  ) {
    emit(FixTheSentenceInitial());
  }

  void _onHintUsed(
    FixTheSentenceHintUsed event,
    Emitter<FixTheSentenceState> emit,
  ) {
    final state = this.state;
    if (state is FixTheSentenceLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
