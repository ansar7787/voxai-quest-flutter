import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/speaking/speak_opposite/domain/usecases/get_speak_opposite_quests.dart';
import 'speak_opposite_event.dart';
import 'speak_opposite_state.dart';

class SpeakOppositeBloc extends Bloc<SpeakOppositeEvent, SpeakOppositeState> {
  final GetSpeakOppositeQuests getQuests;

  SpeakOppositeBloc({required this.getQuests}) : super(SpeakOppositeInitial()) {
    on<FetchSpeakOppositeQuests>(_onFetchQuests);
    on<SubmitSpeakOppositeAnswer>(_onSubmitAnswer);
    on<NextSpeakOppositeQuestion>(_onNextQuestion);
    on<RestoreSpeakOppositeLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchSpeakOppositeQuests event,
    Emitter<SpeakOppositeState> emit,
  ) async {
    emit(SpeakOppositeLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(SpeakOppositeError(failure.message)),
      (quests) => emit(SpeakOppositeLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitSpeakOppositeAnswer event,
    Emitter<SpeakOppositeState> emit,
  ) {
    final state = this.state;
    if (state is SpeakOppositeLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(SpeakOppositeGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextSpeakOppositeQuestion event,
    Emitter<SpeakOppositeState> emit,
  ) {
    final state = this.state;
    if (state is SpeakOppositeLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          SpeakOppositeGameComplete(
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
    RestoreSpeakOppositeLife event,
    Emitter<SpeakOppositeState> emit,
  ) {
    emit(SpeakOppositeInitial());
  }
}
