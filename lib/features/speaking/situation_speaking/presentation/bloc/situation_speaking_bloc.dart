import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/speaking/situation_speaking/domain/usecases/get_situation_speaking_quests.dart';
import 'situation_speaking_event.dart';
import 'situation_speaking_state.dart';

class SituationSpeakingBloc
    extends Bloc<SituationSpeakingEvent, SituationSpeakingState> {
  final GetSituationSpeakingQuests getQuests;

  SituationSpeakingBloc({required this.getQuests})
    : super(SituationSpeakingInitial()) {
    on<FetchSituationSpeakingQuests>(_onFetchQuests);
    on<SubmitSituationSpeakingAnswer>(_onSubmitAnswer);
    on<NextSituationSpeakingQuestion>(_onNextQuestion);
    on<RestoreSituationSpeakingLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchSituationSpeakingQuests event,
    Emitter<SituationSpeakingState> emit,
  ) async {
    emit(SituationSpeakingLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(SituationSpeakingError(failure.message)),
      (quests) => emit(SituationSpeakingLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitSituationSpeakingAnswer event,
    Emitter<SituationSpeakingState> emit,
  ) {
    final state = this.state;
    if (state is SituationSpeakingLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(SituationSpeakingGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextSituationSpeakingQuestion event,
    Emitter<SituationSpeakingState> emit,
  ) {
    final state = this.state;
    if (state is SituationSpeakingLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          SituationSpeakingGameComplete(
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
    RestoreSituationSpeakingLife event,
    Emitter<SituationSpeakingState> emit,
  ) {
    emit(SituationSpeakingInitial());
  }
}
