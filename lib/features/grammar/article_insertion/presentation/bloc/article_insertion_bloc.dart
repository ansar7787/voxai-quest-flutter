import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/grammar/article_insertion/domain/usecases/get_article_insertion_quests.dart';
import 'article_insertion_event.dart';
import 'article_insertion_state.dart';

class ArticleInsertionBloc extends Bloc<ArticleInsertionEvent, ArticleInsertionState> {
  final GetArticleInsertionQuests getQuests;

  ArticleInsertionBloc({required this.getQuests}) : super(ArticleInsertionInitial()) {
    on<FetchArticleInsertionQuests>(_onFetchQuests);
    on<SubmitArticleInsertionAnswer>(_onSubmitAnswer);
    on<NextArticleInsertionQuestion>(_onNextQuestion);
    on<RestoreArticleInsertionLife>(_onRestoreLife);
    on<ArticleInsertionHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchArticleInsertionQuests event,
    Emitter<ArticleInsertionState> emit,
  ) async {
    emit(ArticleInsertionLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(ArticleInsertionError(failure.message)),
      (quests) => emit(ArticleInsertionLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitArticleInsertionAnswer event,
    Emitter<ArticleInsertionState> emit,
  ) {
    final state = this.state;
    if (state is ArticleInsertionLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(ArticleInsertionGameOver());
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
    NextArticleInsertionQuestion event,
    Emitter<ArticleInsertionState> emit,
  ) {
    final state = this.state;
    if (state is ArticleInsertionLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(ArticleInsertionGameComplete(
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
    RestoreArticleInsertionLife event,
    Emitter<ArticleInsertionState> emit,
  ) {
    emit(ArticleInsertionInitial());
  }

  void _onHintUsed(
    ArticleInsertionHintUsed event,
    Emitter<ArticleInsertionState> emit,
  ) {
    final state = this.state;
    if (state is ArticleInsertionLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
