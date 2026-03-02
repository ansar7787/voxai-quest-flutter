import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/listening/ambient_id/domain/usecases/get_ambient_id_quests.dart';
import 'ambient_id_event.dart';
import 'ambient_id_state.dart';

class AmbientIdBloc extends Bloc<AmbientIdEvent, AmbientIdState> {
  final GetAmbientIdQuests getQuests;

  AmbientIdBloc({required this.getQuests}) : super(AmbientIdInitial()) {
    on<FetchAmbientIdQuests>(_onFetchQuests);
    on<SubmitAmbientIdAnswer>(_onSubmitAnswer);
    on<NextAmbientIdQuestion>(_onNextQuestion);
    on<RestoreAmbientIdLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchAmbientIdQuests event,
    Emitter<AmbientIdState> emit,
  ) async {
    emit(AmbientIdLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(AmbientIdError(failure.message)),
      (quests) => emit(AmbientIdLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitAmbientIdAnswer event,
    Emitter<AmbientIdState> emit,
  ) {
    final state = this.state;
    if (state is AmbientIdLoaded) {
      if (event.userIndex == event.correctIndex) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(AmbientIdGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextAmbientIdQuestion event,
    Emitter<AmbientIdState> emit,
  ) {
    final state = this.state;
    if (state is AmbientIdLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          AmbientIdGameComplete(
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
    RestoreAmbientIdLife event,
    Emitter<AmbientIdState> emit,
  ) {
    emit(AmbientIdInitial());
  }
}
