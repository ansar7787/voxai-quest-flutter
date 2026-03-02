import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/vocabulary/flashcards/domain/usecases/get_flashcards_quests.dart';
import 'flashcards_event.dart';
import 'flashcards_state.dart';

class FlashcardsBloc extends Bloc<FlashcardsEvent, FlashcardsState> {
  final GetFlashcardsQuests getQuests;

  FlashcardsBloc({required this.getQuests}) : super(FlashcardsInitial()) {
    on<FetchFlashcardsQuests>(_onFetchQuests);
    on<SubmitFlashcardsAnswer>(_onSubmitAnswer);
    on<NextFlashcardsQuestion>(_onNextQuestion);
    on<RestoreFlashcardsLife>(_onRestoreLife);
    on<FlashcardsHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchFlashcardsQuests event,
    Emitter<FlashcardsState> emit,
  ) async {
    emit(FlashcardsLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(FlashcardsError(failure.message)),
      (quests) {
        if (quests.isEmpty) {
          emit(const FlashcardsError("No quests found for this level."));
        } else {
          emit(FlashcardsLoaded(quests: quests));
        }
      },
    );
  }

  void _onSubmitAnswer(
    SubmitFlashcardsAnswer event,
    Emitter<FlashcardsState> emit,
  ) {
    final state = this.state;
    if (state is FlashcardsLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(FlashcardsGameOver());
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
    NextFlashcardsQuestion event,
    Emitter<FlashcardsState> emit,
  ) {
    final state = this.state;
    if (state is FlashcardsLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(FlashcardsGameComplete(
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
    RestoreFlashcardsLife event,
    Emitter<FlashcardsState> emit,
  ) {
    emit(FlashcardsInitial());
  }

  void _onHintUsed(
    FlashcardsHintUsed event,
    Emitter<FlashcardsState> emit,
  ) {
    final state = this.state;
    if (state is FlashcardsLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
