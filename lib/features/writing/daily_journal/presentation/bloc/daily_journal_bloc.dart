import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/writing/daily_journal/domain/usecases/get_daily_journal_quests.dart';
import 'daily_journal_event.dart';
import 'daily_journal_state.dart';

class DailyJournalBloc extends Bloc<DailyJournalEvent, DailyJournalState> {
  final GetDailyJournalQuests getQuests;

  DailyJournalBloc({required this.getQuests}) : super(DailyJournalInitial()) {
    on<FetchDailyJournalQuests>(_onFetchQuests);
    on<SubmitDailyJournalAnswer>(_onSubmitAnswer);
    on<NextDailyJournalQuestion>(_onNextQuestion);
    on<RestoreDailyJournalLife>(_onRestoreLife);
    on<DailyJournalHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchDailyJournalQuests event,
    Emitter<DailyJournalState> emit,
  ) async {
    emit(DailyJournalLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(DailyJournalError(failure.message)),
      (quests) => emit(DailyJournalLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitDailyJournalAnswer event,
    Emitter<DailyJournalState> emit,
  ) {
    final state = this.state;
    if (state is DailyJournalLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(DailyJournalGameOver());
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
    NextDailyJournalQuestion event,
    Emitter<DailyJournalState> emit,
  ) {
    final state = this.state;
    if (state is DailyJournalLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(DailyJournalGameComplete(
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
    RestoreDailyJournalLife event,
    Emitter<DailyJournalState> emit,
  ) {
    emit(DailyJournalInitial());
  }

  void _onHintUsed(
    DailyJournalHintUsed event,
    Emitter<DailyJournalState> emit,
  ) {
    final state = this.state;
    if (state is DailyJournalLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
