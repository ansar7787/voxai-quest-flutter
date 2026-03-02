import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/vocabulary/idioms/domain/usecases/get_idioms_quests.dart';
import 'idioms_event.dart';
import 'idioms_state.dart';

class IdiomsBloc extends Bloc<IdiomsEvent, IdiomsState> {
  final GetIdiomsQuests getQuests;

  IdiomsBloc({required this.getQuests}) : super(IdiomsInitial()) {
    on<FetchIdiomsQuests>(_onFetchQuests);
    on<SubmitIdiomsAnswer>(_onSubmitAnswer);
    on<NextIdiomsQuestion>(_onNextQuestion);
    on<RestoreIdiomsLife>(_onRestoreLife);
    on<IdiomsHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchIdiomsQuests event,
    Emitter<IdiomsState> emit,
  ) async {
    emit(IdiomsLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(IdiomsError(failure.message)),
      (quests) {
        if (quests.isEmpty) {
          emit(const IdiomsError("No quests found for this level."));
        } else {
          emit(IdiomsLoaded(quests: quests));
        }
      },
    );
  }

  void _onSubmitAnswer(
    SubmitIdiomsAnswer event,
    Emitter<IdiomsState> emit,
  ) {
    final state = this.state;
    if (state is IdiomsLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(IdiomsGameOver());
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
    NextIdiomsQuestion event,
    Emitter<IdiomsState> emit,
  ) {
    final state = this.state;
    if (state is IdiomsLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(IdiomsGameComplete(
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
    RestoreIdiomsLife event,
    Emitter<IdiomsState> emit,
  ) {
    emit(IdiomsInitial());
  }

  void _onHintUsed(
    IdiomsHintUsed event,
    Emitter<IdiomsState> emit,
  ) {
    final state = this.state;
    if (state is IdiomsLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
