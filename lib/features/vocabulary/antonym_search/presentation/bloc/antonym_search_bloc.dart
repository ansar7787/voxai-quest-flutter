import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/vocabulary/antonym_search/domain/usecases/get_antonym_search_quests.dart';
import 'antonym_search_event.dart';
import 'antonym_search_state.dart';

class AntonymSearchBloc extends Bloc<AntonymSearchEvent, AntonymSearchState> {
  final GetAntonymSearchQuests getQuests;

  AntonymSearchBloc({required this.getQuests}) : super(AntonymSearchInitial()) {
    on<FetchAntonymSearchQuests>(_onFetchQuests);
    on<SubmitAntonymSearchAnswer>(_onSubmitAnswer);
    on<NextAntonymSearchQuestion>(_onNextQuestion);
    on<RestoreAntonymSearchLife>(_onRestoreLife);
    on<AntonymSearchHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchAntonymSearchQuests event,
    Emitter<AntonymSearchState> emit,
  ) async {
    emit(AntonymSearchLoading());
    final result = await getQuests(event.level);
    result.fold((failure) => emit(AntonymSearchError(failure.message)), (
      quests,
    ) {
      if (quests.isEmpty) {
        emit(const AntonymSearchError("No quests found for this level."));
      } else {
        emit(AntonymSearchLoaded(quests: quests));
      }
    });
  }

  void _onSubmitAnswer(
    SubmitAntonymSearchAnswer event,
    Emitter<AntonymSearchState> emit,
  ) {
    final state = this.state;
    if (state is AntonymSearchLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(AntonymSearchGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextAntonymSearchQuestion event,
    Emitter<AntonymSearchState> emit,
  ) {
    final state = this.state;
    if (state is AntonymSearchLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          AntonymSearchGameComplete(
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
    RestoreAntonymSearchLife event,
    Emitter<AntonymSearchState> emit,
  ) {
    emit(AntonymSearchInitial());
  }

  void _onHintUsed(
    AntonymSearchHintUsed event,
    Emitter<AntonymSearchState> emit,
  ) {
    final state = this.state;
    if (state is AntonymSearchLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
