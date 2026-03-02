import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/writing/describe_situation_writing/domain/usecases/get_describe_situation_writing_quests.dart';
import 'describe_situation_writing_event.dart';
import 'describe_situation_writing_state.dart';

class DescribeSituationWritingBloc
    extends Bloc<DescribeSituationWritingEvent, DescribeSituationWritingState> {
  final GetDescribeSituationWritingQuests getQuests;

  DescribeSituationWritingBloc({required this.getQuests})
    : super(DescribeSituationWritingInitial()) {
    on<FetchDescribeSituationWritingQuests>(_onFetchQuests);
    on<SubmitDescribeSituationWritingAnswer>(_onSubmitAnswer);
    on<NextDescribeSituationWritingQuestion>(_onNextQuestion);
    on<RestoreDescribeSituationWritingLife>(_onRestoreLife);
    on<DescribeSituationWritingHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchDescribeSituationWritingQuests event,
    Emitter<DescribeSituationWritingState> emit,
  ) async {
    emit(DescribeSituationWritingLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(DescribeSituationWritingError(failure.message)),
      (quests) => emit(DescribeSituationWritingLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitDescribeSituationWritingAnswer event,
    Emitter<DescribeSituationWritingState> emit,
  ) {
    final state = this.state;
    if (state is DescribeSituationWritingLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(DescribeSituationWritingGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextDescribeSituationWritingQuestion event,
    Emitter<DescribeSituationWritingState> emit,
  ) {
    final state = this.state;
    if (state is DescribeSituationWritingLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          DescribeSituationWritingGameComplete(
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
    RestoreDescribeSituationWritingLife event,
    Emitter<DescribeSituationWritingState> emit,
  ) {
    emit(DescribeSituationWritingInitial());
  }

  void _onHintUsed(
    DescribeSituationWritingHintUsed event,
    Emitter<DescribeSituationWritingState> emit,
  ) {
    final state = this.state;
    if (state is DescribeSituationWritingLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
