import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/speaking/scene_description_speaking/domain/usecases/get_scene_description_speaking_quests.dart';
import 'scene_description_speaking_event.dart';
import 'scene_description_speaking_state.dart';

class SceneDescriptionSpeakingBloc
    extends Bloc<SceneDescriptionSpeakingEvent, SceneDescriptionSpeakingState> {
  final GetSceneDescriptionSpeakingQuests getQuests;

  SceneDescriptionSpeakingBloc({required this.getQuests})
    : super(SceneDescriptionSpeakingInitial()) {
    on<FetchSceneDescriptionSpeakingQuests>(_onFetchQuests);
    on<SubmitSceneDescriptionSpeakingAnswer>(_onSubmitAnswer);
    on<NextSceneDescriptionSpeakingQuestion>(_onNextQuestion);
    on<RestoreSceneDescriptionSpeakingLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchSceneDescriptionSpeakingQuests event,
    Emitter<SceneDescriptionSpeakingState> emit,
  ) async {
    emit(SceneDescriptionSpeakingLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(SceneDescriptionSpeakingError(failure.message)),
      (quests) => emit(SceneDescriptionSpeakingLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitSceneDescriptionSpeakingAnswer event,
    Emitter<SceneDescriptionSpeakingState> emit,
  ) {
    final state = this.state;
    if (state is SceneDescriptionSpeakingLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(SceneDescriptionSpeakingGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextSceneDescriptionSpeakingQuestion event,
    Emitter<SceneDescriptionSpeakingState> emit,
  ) {
    final state = this.state;
    if (state is SceneDescriptionSpeakingLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          SceneDescriptionSpeakingGameComplete(
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
    RestoreSceneDescriptionSpeakingLife event,
    Emitter<SceneDescriptionSpeakingState> emit,
  ) {
    emit(SceneDescriptionSpeakingInitial());
  }
}
