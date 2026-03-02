import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/listening/fast_speech_decoder/domain/usecases/get_fast_speech_decoder_quests.dart';
import 'fast_speech_decoder_event.dart';
import 'fast_speech_decoder_state.dart';

class FastSpeechDecoderBloc
    extends Bloc<FastSpeechDecoderEvent, FastSpeechDecoderState> {
  final GetFastSpeechDecoderQuests getQuests;

  FastSpeechDecoderBloc({required this.getQuests})
    : super(FastSpeechDecoderInitial()) {
    on<FetchFastSpeechDecoderQuests>(_onFetchQuests);
    on<SubmitFastSpeechDecoderAnswer>(_onSubmitAnswer);
    on<NextFastSpeechDecoderQuestion>(_onNextQuestion);
    on<RestoreFastSpeechDecoderLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchFastSpeechDecoderQuests event,
    Emitter<FastSpeechDecoderState> emit,
  ) async {
    emit(FastSpeechDecoderLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(FastSpeechDecoderError(failure.message)),
      (quests) => emit(FastSpeechDecoderLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitFastSpeechDecoderAnswer event,
    Emitter<FastSpeechDecoderState> emit,
  ) {
    final state = this.state;
    if (state is FastSpeechDecoderLoaded) {
      final normalizedInput = event.answer.trim().toLowerCase().replaceAll(
        RegExp(r'[^\w\s]'),
        '',
      );
      final normalizedCorrect = event.correctAnswer
          .trim()
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), '');

      final isCorrect = normalizedInput == normalizedCorrect;

      if (isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(FastSpeechDecoderGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextFastSpeechDecoderQuestion event,
    Emitter<FastSpeechDecoderState> emit,
  ) {
    final state = this.state;
    if (state is FastSpeechDecoderLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          FastSpeechDecoderGameComplete(
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
    RestoreFastSpeechDecoderLife event,
    Emitter<FastSpeechDecoderState> emit,
  ) {
    emit(FastSpeechDecoderInitial());
  }
}
