import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/grammar/sentence_correction/domain/usecases/get_sentence_correction_quests.dart';
import 'sentence_correction_event.dart';
import 'sentence_correction_state.dart';

class SentenceCorrectionBloc
    extends Bloc<SentenceCorrectionEvent, SentenceCorrectionState> {
  final GetSentenceCorrectionQuests getQuests;

  SentenceCorrectionBloc({required this.getQuests})
    : super(SentenceCorrectionInitial()) {
    on<FetchSentenceCorrectionQuests>(_onFetchQuests);
    on<SubmitSentenceCorrectionAnswer>(_onSubmitAnswer);
    on<NextSentenceCorrectionQuestion>(_onNextQuestion);
    on<RestoreSentenceCorrectionLife>(_onRestoreLife);
    on<SentenceCorrectionHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchSentenceCorrectionQuests event,
    Emitter<SentenceCorrectionState> emit,
  ) async {
    emit(SentenceCorrectionLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(SentenceCorrectionError(failure.message)),
      (quests) => emit(SentenceCorrectionLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitSentenceCorrectionAnswer event,
    Emitter<SentenceCorrectionState> emit,
  ) {
    final state = this.state;
    if (state is SentenceCorrectionLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(SentenceCorrectionGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextSentenceCorrectionQuestion event,
    Emitter<SentenceCorrectionState> emit,
  ) {
    final state = this.state;
    if (state is SentenceCorrectionLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          SentenceCorrectionGameComplete(
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
    RestoreSentenceCorrectionLife event,
    Emitter<SentenceCorrectionState> emit,
  ) {
    emit(SentenceCorrectionInitial());
  }

  void _onHintUsed(
    SentenceCorrectionHintUsed event,
    Emitter<SentenceCorrectionState> emit,
  ) {
    final state = this.state;
    if (state is SentenceCorrectionLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
