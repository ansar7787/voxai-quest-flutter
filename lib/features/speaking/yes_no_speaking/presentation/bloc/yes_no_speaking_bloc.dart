import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/speaking/yes_no_speaking/domain/usecases/get_yes_no_speaking_quests.dart';
import 'yes_no_speaking_event.dart';
import 'yes_no_speaking_state.dart';

class YesNoSpeakingBloc extends Bloc<YesNoSpeakingEvent, YesNoSpeakingState> {
  final GetYesNoSpeakingQuests getQuests;

  YesNoSpeakingBloc({required this.getQuests}) : super(YesNoSpeakingInitial()) {
    on<FetchYesNoSpeakingQuests>(_onFetchQuests);
    on<SubmitYesNoSpeakingAnswer>(_onSubmitAnswer);
    on<NextYesNoSpeakingQuestion>(_onNextQuestion);
    on<RestoreYesNoSpeakingLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchYesNoSpeakingQuests event,
    Emitter<YesNoSpeakingState> emit,
  ) async {
    emit(YesNoSpeakingLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(YesNoSpeakingError(failure.message)),
      (quests) => emit(YesNoSpeakingLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitYesNoSpeakingAnswer event,
    Emitter<YesNoSpeakingState> emit,
  ) {
    final state = this.state;
    if (state is YesNoSpeakingLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(YesNoSpeakingGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextYesNoSpeakingQuestion event,
    Emitter<YesNoSpeakingState> emit,
  ) {
    final state = this.state;
    if (state is YesNoSpeakingLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          YesNoSpeakingGameComplete(
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
    RestoreYesNoSpeakingLife event,
    Emitter<YesNoSpeakingState> emit,
  ) {
    emit(YesNoSpeakingInitial());
  }
}
