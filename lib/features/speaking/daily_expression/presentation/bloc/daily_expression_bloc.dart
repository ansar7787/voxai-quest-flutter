import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/speaking/daily_expression/domain/usecases/get_daily_expression_quests.dart';
import 'daily_expression_event.dart';
import 'daily_expression_state.dart';

class DailyExpressionBloc
    extends Bloc<DailyExpressionEvent, DailyExpressionState> {
  final GetDailyExpressionQuests getQuests;

  DailyExpressionBloc({required this.getQuests})
    : super(DailyExpressionInitial()) {
    on<FetchDailyExpressionQuests>(_onFetchQuests);
    on<SubmitDailyExpressionAnswer>(_onSubmitAnswer);
    on<NextDailyExpressionQuestion>(_onNextQuestion);
    on<RestoreDailyExpressionLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchDailyExpressionQuests event,
    Emitter<DailyExpressionState> emit,
  ) async {
    emit(DailyExpressionLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(DailyExpressionError(failure.message)),
      (quests) => emit(DailyExpressionLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitDailyExpressionAnswer event,
    Emitter<DailyExpressionState> emit,
  ) {
    final state = this.state;
    if (state is DailyExpressionLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(DailyExpressionGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextDailyExpressionQuestion event,
    Emitter<DailyExpressionState> emit,
  ) {
    final state = this.state;
    if (state is DailyExpressionLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          DailyExpressionGameComplete(
            xpEarned: totalQuests * 10,
            coinsEarned: totalQuests * 5,
          ),
        );
      } else {
        emit(state.copyWith(currentIndex: nextIndex, lastAnswerCorrect: null));
      }
    }
  }

  void _onRestoreLife(
    RestoreDailyExpressionLife event,
    Emitter<DailyExpressionState> emit,
  ) {
    emit(DailyExpressionInitial());
  }
}
