import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/vocabulary/synonym_search/domain/usecases/get_synonym_search_quests.dart';
import 'synonym_search_event.dart';
import 'synonym_search_state.dart';

class SynonymSearchBloc extends Bloc<SynonymSearchEvent, SynonymSearchState> {
  final GetSynonymSearchQuests getQuests;

  SynonymSearchBloc({required this.getQuests}) : super(SynonymSearchInitial()) {
    on<FetchSynonymSearchQuests>(_onFetchQuests);
    on<SubmitSynonymSearchAnswer>(_onSubmitAnswer);
    on<NextSynonymSearchQuestion>(_onNextQuestion);
    on<RestoreSynonymSearchLife>(_onRestoreLife);
    on<SynonymSearchHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchSynonymSearchQuests event,
    Emitter<SynonymSearchState> emit,
  ) async {
    emit(SynonymSearchLoading());
    final result = await getQuests(event.level);
    result.fold((failure) => emit(SynonymSearchError(failure.message)), (
      quests,
    ) {
      if (quests.isEmpty) {
        emit(const SynonymSearchError("No quests found for this level."));
      } else {
        emit(SynonymSearchLoaded(quests: quests));
      }
    });
  }

  void _onSubmitAnswer(
    SubmitSynonymSearchAnswer event,
    Emitter<SynonymSearchState> emit,
  ) {
    final state = this.state;
    if (state is SynonymSearchLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(SynonymSearchGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextSynonymSearchQuestion event,
    Emitter<SynonymSearchState> emit,
  ) {
    final state = this.state;
    if (state is SynonymSearchLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          SynonymSearchGameComplete(
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
    RestoreSynonymSearchLife event,
    Emitter<SynonymSearchState> emit,
  ) {
    // This event is usually triggered to reset the game or restore lives via ad/coins
    // For now, let's just reset to initial or handled level reload
    emit(SynonymSearchInitial());
  }

  void _onHintUsed(
    SynonymSearchHintUsed event,
    Emitter<SynonymSearchState> emit,
  ) {
    final state = this.state;
    if (state is SynonymSearchLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
