import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/roleplay/social_spark/domain/usecases/get_social_spark_quests.dart';
import 'social_spark_event.dart';
import 'social_spark_state.dart';

class SocialSparkBloc extends Bloc<SocialSparkEvent, SocialSparkState> {
  final GetSocialSparkQuests getQuests;

  SocialSparkBloc({required this.getQuests}) : super(SocialSparkInitial()) {
    on<RestartLevel>((event, emit) => emit(SocialSparkInitial()));
    on<FetchSocialSparkQuests>(_onFetchQuests);
    on<SubmitSocialSparkAnswer>(_onSubmitAnswer);
    on<NextSocialSparkQuestion>(_onNextQuestion);
    on<RestoreSocialSparkLife>(_onRestoreLife);
    on<SocialSparkHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchSocialSparkQuests event,
    Emitter<SocialSparkState> emit,
  ) async {
    emit(SocialSparkLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) =>
          emit(const SocialSparkError("Failed to load social spark quests")),
      (quests) => emit(SocialSparkLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitSocialSparkAnswer event,
    Emitter<SocialSparkState> emit,
  ) {
    final state = this.state;
    if (state is SocialSparkLoaded) {
      final isCorrect = event.isCorrect;
      final newLives = isCorrect
          ? state.livesRemaining
          : state.livesRemaining - 1;

      if (newLives <= 0) {
        emit(SocialSparkGameOver());
      } else {
        emit(
          state.copyWith(
            livesRemaining: newLives,
            lastAnswerCorrect: isCorrect,
            xpEarned: isCorrect
                ? state.xpEarned + state.currentQuest.xpReward
                : state.xpEarned,
            coinsEarned: isCorrect
                ? state.coinsEarned + state.currentQuest.coinReward
                : state.coinsEarned,
          ),
        );
      }
    }
  }

  void _onNextQuestion(
    NextSocialSparkQuestion event,
    Emitter<SocialSparkState> emit,
  ) {
    final state = this.state;
    if (state is SocialSparkLoaded) {
      if (state.currentIndex + 1 < state.quests.length) {
        emit(
          state.copyWith(
            currentIndex: state.currentIndex + 1,
            lastAnswerCorrect: null,
          ),
        );
      } else {
        emit(
          SocialSparkGameComplete(
            xpEarned: state.xpEarned,
            coinsEarned: state.coinsEarned,
          ),
        );
      }
    }
  }

  void _onRestoreLife(
    RestoreSocialSparkLife event,
    Emitter<SocialSparkState> emit,
  ) {
    final state = this.state;
    if (state is SocialSparkLoaded) {
      emit(state.copyWith(livesRemaining: 3));
    }
  }

  void _onHintUsed(SocialSparkHintUsed event, Emitter<SocialSparkState> emit) {
    // Implement hint logic if needed
  }
}
