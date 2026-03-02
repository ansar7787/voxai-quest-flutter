import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/vocabulary/prefix_suffix/domain/usecases/get_prefix_suffix_quests.dart';
import 'prefix_suffix_event.dart';
import 'prefix_suffix_state.dart';

class PrefixSuffixBloc extends Bloc<PrefixSuffixEvent, PrefixSuffixState> {
  final GetPrefixSuffixQuests getQuests;

  PrefixSuffixBloc({required this.getQuests}) : super(PrefixSuffixInitial()) {
    on<FetchPrefixSuffixQuests>(_onFetchQuests);
    on<SubmitPrefixSuffixAnswer>(_onSubmitAnswer);
    on<NextPrefixSuffixQuestion>(_onNextQuestion);
    on<RestorePrefixSuffixLife>(_onRestoreLife);
    on<PrefixSuffixHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchPrefixSuffixQuests event,
    Emitter<PrefixSuffixState> emit,
  ) async {
    emit(PrefixSuffixLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(PrefixSuffixError(failure.message)),
      (quests) {
        if (quests.isEmpty) {
          emit(const PrefixSuffixError("No quests found for this level."));
        } else {
          emit(PrefixSuffixLoaded(quests: quests));
        }
      },
    );
  }

  void _onSubmitAnswer(
    SubmitPrefixSuffixAnswer event,
    Emitter<PrefixSuffixState> emit,
  ) {
    final state = this.state;
    if (state is PrefixSuffixLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(PrefixSuffixGameOver());
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
    NextPrefixSuffixQuestion event,
    Emitter<PrefixSuffixState> emit,
  ) {
    final state = this.state;
    if (state is PrefixSuffixLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(PrefixSuffixGameComplete(
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
    RestorePrefixSuffixLife event,
    Emitter<PrefixSuffixState> emit,
  ) {
    emit(PrefixSuffixInitial());
  }

  void _onHintUsed(
    PrefixSuffixHintUsed event,
    Emitter<PrefixSuffixState> emit,
  ) {
    final state = this.state;
    if (state is PrefixSuffixLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
