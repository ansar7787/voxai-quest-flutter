import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/grammar/parts_of_speech/domain/usecases/get_parts_of_speech_quests.dart';
import 'parts_of_speech_event.dart';
import 'parts_of_speech_state.dart';

class PartsOfSpeechBloc extends Bloc<PartsOfSpeechEvent, PartsOfSpeechState> {
  final GetPartsOfSpeechQuests getQuests;

  PartsOfSpeechBloc({required this.getQuests}) : super(PartsOfSpeechInitial()) {
    on<FetchPartsOfSpeechQuests>(_onFetchQuests);
    on<SubmitPartsOfSpeechAnswer>(_onSubmitAnswer);
    on<NextPartsOfSpeechQuestion>(_onNextQuestion);
    on<RestorePartsOfSpeechLife>(_onRestoreLife);
    on<PartsOfSpeechHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchPartsOfSpeechQuests event,
    Emitter<PartsOfSpeechState> emit,
  ) async {
    emit(PartsOfSpeechLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(PartsOfSpeechError(failure.message)),
      (quests) => emit(PartsOfSpeechLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitPartsOfSpeechAnswer event,
    Emitter<PartsOfSpeechState> emit,
  ) {
    final state = this.state;
    if (state is PartsOfSpeechLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(PartsOfSpeechGameOver());
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
    NextPartsOfSpeechQuestion event,
    Emitter<PartsOfSpeechState> emit,
  ) {
    final state = this.state;
    if (state is PartsOfSpeechLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(PartsOfSpeechGameComplete(
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
    RestorePartsOfSpeechLife event,
    Emitter<PartsOfSpeechState> emit,
  ) {
    emit(PartsOfSpeechInitial());
  }

  void _onHintUsed(
    PartsOfSpeechHintUsed event,
    Emitter<PartsOfSpeechState> emit,
  ) {
    final state = this.state;
    if (state is PartsOfSpeechLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
