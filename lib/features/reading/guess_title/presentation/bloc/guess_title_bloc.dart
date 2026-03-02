import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/reading/guess_title/domain/usecases/get_guess_title_quests.dart';
import 'guess_title_event.dart';
import 'guess_title_state.dart';

class GuessTitleBloc extends Bloc<GuessTitleEvent, GuessTitleState> {
  final GetGuessTitleQuests getQuests;

  GuessTitleBloc({required this.getQuests}) : super(GuessTitleInitial()) {
    on<FetchGuessTitleQuests>(_onFetchQuests);
    on<SubmitGuessTitleAnswer>(_onSubmitAnswer);
    on<NextGuessTitleQuestion>(_onNextQuestion);
    on<RestoreGuessTitleLife>(_onRestoreLife);
    on<GuessTitleHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchGuessTitleQuests event,
    Emitter<GuessTitleState> emit,
  ) async {
    emit(GuessTitleLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(GuessTitleError(failure.message)),
      (quests) => emit(GuessTitleLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitGuessTitleAnswer event,
    Emitter<GuessTitleState> emit,
  ) {
    final state = this.state;
    if (state is GuessTitleLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(GuessTitleGameOver());
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
    NextGuessTitleQuestion event,
    Emitter<GuessTitleState> emit,
  ) {
    final state = this.state;
    if (state is GuessTitleLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(GuessTitleGameComplete(
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
    RestoreGuessTitleLife event,
    Emitter<GuessTitleState> emit,
  ) {
    emit(GuessTitleInitial());
  }

  void _onHintUsed(
    GuessTitleHintUsed event,
    Emitter<GuessTitleState> emit,
  ) {
    final state = this.state;
    if (state is GuessTitleLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
