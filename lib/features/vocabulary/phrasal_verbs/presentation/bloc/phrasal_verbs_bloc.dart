import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/vocabulary/phrasal_verbs/domain/usecases/get_phrasal_verbs_quests.dart';
import 'phrasal_verbs_event.dart';
import 'phrasal_verbs_state.dart';

class PhrasalVerbsBloc extends Bloc<PhrasalVerbsEvent, PhrasalVerbsState> {
  final GetPhrasalVerbsQuests getQuests;

  PhrasalVerbsBloc({required this.getQuests}) : super(PhrasalVerbsInitial()) {
    on<FetchPhrasalVerbsQuests>(_onFetchQuests);
    on<SubmitPhrasalVerbsAnswer>(_onSubmitAnswer);
    on<NextPhrasalVerbsQuestion>(_onNextQuestion);
    on<RestorePhrasalVerbsLife>(_onRestoreLife);
    on<PhrasalVerbsHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchPhrasalVerbsQuests event,
    Emitter<PhrasalVerbsState> emit,
  ) async {
    emit(PhrasalVerbsLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(PhrasalVerbsError(failure.message)),
      (quests) {
        if (quests.isEmpty) {
          emit(const PhrasalVerbsError("No quests found for this level."));
        } else {
          emit(PhrasalVerbsLoaded(quests: quests));
        }
      },
    );
  }

  void _onSubmitAnswer(
    SubmitPhrasalVerbsAnswer event,
    Emitter<PhrasalVerbsState> emit,
  ) {
    final state = this.state;
    if (state is PhrasalVerbsLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(PhrasalVerbsGameOver());
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
    NextPhrasalVerbsQuestion event,
    Emitter<PhrasalVerbsState> emit,
  ) {
    final state = this.state;
    if (state is PhrasalVerbsLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(PhrasalVerbsGameComplete(
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
    RestorePhrasalVerbsLife event,
    Emitter<PhrasalVerbsState> emit,
  ) {
    emit(PhrasalVerbsInitial());
  }

  void _onHintUsed(
    PhrasalVerbsHintUsed event,
    Emitter<PhrasalVerbsState> emit,
  ) {
    final state = this.state;
    if (state is PhrasalVerbsLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
