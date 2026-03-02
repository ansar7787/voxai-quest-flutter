import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/grammar/question_formatter/domain/usecases/get_question_formatter_quests.dart';
import 'question_formatter_event.dart';
import 'question_formatter_state.dart';

class QuestionFormatterBloc
    extends Bloc<QuestionFormatterEvent, QuestionFormatterState> {
  final GetQuestionFormatterQuests getQuests;

  QuestionFormatterBloc({required this.getQuests})
    : super(QuestionFormatterInitial()) {
    on<FetchQuestionFormatterQuests>(_onFetchQuests);
    on<SubmitQuestionFormatterAnswer>(_onSubmitAnswer);
    on<NextQuestionFormatterQuestion>(_onNextQuestion);
    on<RestoreQuestionFormatterLife>(_onRestoreLife);
    on<QuestionFormatterHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchQuestionFormatterQuests event,
    Emitter<QuestionFormatterState> emit,
  ) async {
    emit(QuestionFormatterLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(QuestionFormatterError(failure.message)),
      (quests) => emit(QuestionFormatterLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitQuestionFormatterAnswer event,
    Emitter<QuestionFormatterState> emit,
  ) {
    final state = this.state;
    if (state is QuestionFormatterLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(QuestionFormatterGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextQuestionFormatterQuestion event,
    Emitter<QuestionFormatterState> emit,
  ) {
    final state = this.state;
    if (state is QuestionFormatterLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          QuestionFormatterGameComplete(
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
    RestoreQuestionFormatterLife event,
    Emitter<QuestionFormatterState> emit,
  ) {
    emit(QuestionFormatterInitial());
  }

  void _onHintUsed(
    QuestionFormatterHintUsed event,
    Emitter<QuestionFormatterState> emit,
  ) {
    final state = this.state;
    if (state is QuestionFormatterLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
