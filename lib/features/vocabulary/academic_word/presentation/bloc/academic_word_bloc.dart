import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/vocabulary/academic_word/domain/usecases/get_academic_word_quests.dart';
import 'academic_word_event.dart';
import 'academic_word_state.dart';

class AcademicWordBloc extends Bloc<AcademicWordEvent, AcademicWordState> {
  final GetAcademicWordQuests getQuests;

  AcademicWordBloc({required this.getQuests}) : super(AcademicWordInitial()) {
    on<FetchAcademicWordQuests>(_onFetchQuests);
    on<SubmitAcademicWordAnswer>(_onSubmitAnswer);
    on<NextAcademicWordQuestion>(_onNextQuestion);
    on<RestoreAcademicWordLife>(_onRestoreLife);
    on<AcademicWordHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchAcademicWordQuests event,
    Emitter<AcademicWordState> emit,
  ) async {
    emit(AcademicWordLoading());
    final result = await getQuests(event.level);
    result.fold((failure) => emit(AcademicWordError(failure.message)), (
      quests,
    ) {
      if (quests.isEmpty) {
        emit(const AcademicWordError("No quests found for this level."));
      } else {
        emit(AcademicWordLoaded(quests: quests));
      }
    });
  }

  void _onSubmitAnswer(
    SubmitAcademicWordAnswer event,
    Emitter<AcademicWordState> emit,
  ) {
    final state = this.state;
    if (state is AcademicWordLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(AcademicWordGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextAcademicWordQuestion event,
    Emitter<AcademicWordState> emit,
  ) {
    final state = this.state;
    if (state is AcademicWordLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          AcademicWordGameComplete(
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
    RestoreAcademicWordLife event,
    Emitter<AcademicWordState> emit,
  ) {
    emit(AcademicWordInitial());
  }

  void _onHintUsed(
    AcademicWordHintUsed event,
    Emitter<AcademicWordState> emit,
  ) {
    final state = this.state;
    if (state is AcademicWordLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
