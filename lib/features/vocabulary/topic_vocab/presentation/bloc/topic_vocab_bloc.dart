import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/vocabulary/topic_vocab/domain/usecases/get_topic_vocab_quests.dart';
import 'topic_vocab_event.dart';
import 'topic_vocab_state.dart';

class TopicVocabBloc extends Bloc<TopicVocabEvent, TopicVocabState> {
  final GetTopicVocabQuests getQuests;

  TopicVocabBloc({required this.getQuests}) : super(TopicVocabInitial()) {
    on<FetchTopicVocabQuests>(_onFetchQuests);
    on<SubmitTopicVocabAnswer>(_onSubmitAnswer);
    on<NextTopicVocabQuestion>(_onNextQuestion);
    on<RestoreTopicVocabLife>(_onRestoreLife);
    on<TopicVocabHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchTopicVocabQuests event,
    Emitter<TopicVocabState> emit,
  ) async {
    emit(TopicVocabLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(TopicVocabError(failure.message)),
      (quests) {
        if (quests.isEmpty) {
          emit(const TopicVocabError("No quests found for this level."));
        } else {
          emit(TopicVocabLoaded(quests: quests));
        }
      },
    );
  }

  void _onSubmitAnswer(
    SubmitTopicVocabAnswer event,
    Emitter<TopicVocabState> emit,
  ) {
    final state = this.state;
    if (state is TopicVocabLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(TopicVocabGameOver());
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
    NextTopicVocabQuestion event,
    Emitter<TopicVocabState> emit,
  ) {
    final state = this.state;
    if (state is TopicVocabLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(TopicVocabGameComplete(
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
    RestoreTopicVocabLife event,
    Emitter<TopicVocabState> emit,
  ) {
    emit(TopicVocabInitial());
  }

  void _onHintUsed(
    TopicVocabHintUsed event,
    Emitter<TopicVocabState> emit,
  ) {
    final state = this.state;
    if (state is TopicVocabLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
