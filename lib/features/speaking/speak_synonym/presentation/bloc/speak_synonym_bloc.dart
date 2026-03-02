import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/speaking/speak_synonym/domain/usecases/get_speak_synonym_quests.dart';
import 'speak_synonym_event.dart';
import 'speak_synonym_state.dart';

class SpeakSynonymBloc extends Bloc<SpeakSynonymEvent, SpeakSynonymState> {
  final GetSpeakSynonymQuests getQuests;

  SpeakSynonymBloc({required this.getQuests}) : super(SpeakSynonymInitial()) {
    on<FetchSpeakSynonymQuests>(_onFetchQuests);
    on<SubmitSpeakSynonymAnswer>(_onSubmitAnswer);
    on<NextSpeakSynonymQuestion>(_onNextQuestion);
    on<RestoreSpeakSynonymLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchSpeakSynonymQuests event,
    Emitter<SpeakSynonymState> emit,
  ) async {
    emit(SpeakSynonymLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(SpeakSynonymError(failure.message)),
      (quests) => emit(SpeakSynonymLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitSpeakSynonymAnswer event,
    Emitter<SpeakSynonymState> emit,
  ) {
    final state = this.state;
    if (state is SpeakSynonymLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(SpeakSynonymGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextSpeakSynonymQuestion event,
    Emitter<SpeakSynonymState> emit,
  ) {
    final state = this.state;
    if (state is SpeakSynonymLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          SpeakSynonymGameComplete(
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
    RestoreSpeakSynonymLife event,
    Emitter<SpeakSynonymState> emit,
  ) {
    emit(SpeakSynonymInitial());
  }
}
