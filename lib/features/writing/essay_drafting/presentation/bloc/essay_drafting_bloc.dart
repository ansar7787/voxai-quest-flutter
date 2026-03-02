import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/writing/essay_drafting/domain/usecases/get_essay_drafting_quests.dart';
import 'essay_drafting_event.dart';
import 'essay_drafting_state.dart';

class EssayDraftingBloc extends Bloc<EssayDraftingEvent, EssayDraftingState> {
  final GetEssayDraftingQuests getQuests;

  EssayDraftingBloc({required this.getQuests}) : super(EssayDraftingInitial()) {
    on<FetchEssayDraftingQuests>(_onFetchQuests);
    on<SubmitEssayDraftingAnswer>(_onSubmitAnswer);
    on<NextEssayDraftingQuestion>(_onNextQuestion);
    on<RestoreEssayDraftingLife>(_onRestoreLife);
    on<EssayDraftingHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchEssayDraftingQuests event,
    Emitter<EssayDraftingState> emit,
  ) async {
    emit(EssayDraftingLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(EssayDraftingError(failure.message)),
      (quests) => emit(EssayDraftingLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitEssayDraftingAnswer event,
    Emitter<EssayDraftingState> emit,
  ) {
    final state = this.state;
    if (state is EssayDraftingLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(EssayDraftingGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextEssayDraftingQuestion event,
    Emitter<EssayDraftingState> emit,
  ) {
    final state = this.state;
    if (state is EssayDraftingLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          EssayDraftingGameComplete(
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
    RestoreEssayDraftingLife event,
    Emitter<EssayDraftingState> emit,
  ) {
    emit(EssayDraftingInitial());
  }

  void _onHintUsed(
    EssayDraftingHintUsed event,
    Emitter<EssayDraftingState> emit,
  ) {
    final state = this.state;
    if (state is EssayDraftingLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
