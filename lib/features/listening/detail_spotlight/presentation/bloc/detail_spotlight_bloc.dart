import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/listening/detail_spotlight/domain/usecases/get_detail_spotlight_quests.dart';
import 'detail_spotlight_event.dart';
import 'detail_spotlight_state.dart';

class DetailSpotlightBloc
    extends Bloc<DetailSpotlightEvent, DetailSpotlightState> {
  final GetDetailSpotlightQuests getQuests;

  DetailSpotlightBloc({required this.getQuests})
    : super(DetailSpotlightInitial()) {
    on<FetchDetailSpotlightQuests>(_onFetchQuests);
    on<SubmitDetailSpotlightAnswer>(_onSubmitAnswer);
    on<NextDetailSpotlightQuestion>(_onNextQuestion);
    on<RestoreDetailSpotlightLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchDetailSpotlightQuests event,
    Emitter<DetailSpotlightState> emit,
  ) async {
    emit(DetailSpotlightLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(DetailSpotlightError(failure.message)),
      (quests) => emit(DetailSpotlightLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitDetailSpotlightAnswer event,
    Emitter<DetailSpotlightState> emit,
  ) {
    final state = this.state;
    if (state is DetailSpotlightLoaded) {
      if (event.userIndex == event.correctIndex) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(DetailSpotlightGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextDetailSpotlightQuestion event,
    Emitter<DetailSpotlightState> emit,
  ) {
    final state = this.state;
    if (state is DetailSpotlightLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          DetailSpotlightGameComplete(
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
    RestoreDetailSpotlightLife event,
    Emitter<DetailSpotlightState> emit,
  ) {
    emit(DetailSpotlightInitial());
  }
}
