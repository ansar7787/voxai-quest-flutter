import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/writing/writing_email/domain/usecases/get_writing_email_quests.dart';
import 'writing_email_event.dart';
import 'writing_email_state.dart';

class WritingEmailBloc extends Bloc<WritingEmailEvent, WritingEmailState> {
  final GetWritingEmailQuests getQuests;

  WritingEmailBloc({required this.getQuests}) : super(WritingEmailInitial()) {
    on<FetchWritingEmailQuests>(_onFetchQuests);
    on<SubmitWritingEmailAnswer>(_onSubmitAnswer);
    on<NextWritingEmailQuestion>(_onNextQuestion);
    on<RestoreWritingEmailLife>(_onRestoreLife);
    on<WritingEmailHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchWritingEmailQuests event,
    Emitter<WritingEmailState> emit,
  ) async {
    emit(WritingEmailLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(WritingEmailError(failure.message)),
      (quests) => emit(WritingEmailLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitWritingEmailAnswer event,
    Emitter<WritingEmailState> emit,
  ) {
    final state = this.state;
    if (state is WritingEmailLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(WritingEmailGameOver());
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
    NextWritingEmailQuestion event,
    Emitter<WritingEmailState> emit,
  ) {
    final state = this.state;
    if (state is WritingEmailLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(WritingEmailGameComplete(
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
    RestoreWritingEmailLife event,
    Emitter<WritingEmailState> emit,
  ) {
    emit(WritingEmailInitial());
  }

  void _onHintUsed(
    WritingEmailHintUsed event,
    Emitter<WritingEmailState> emit,
  ) {
    final state = this.state;
    if (state is WritingEmailLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
