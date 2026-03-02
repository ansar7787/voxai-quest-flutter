import 'package:equatable/equatable.dart';

abstract class ArticleInsertionEvent extends Equatable {
  const ArticleInsertionEvent();

  @override
  List<Object?> get props => [];
}

class FetchArticleInsertionQuests extends ArticleInsertionEvent {
  final int level;

  const FetchArticleInsertionQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitArticleInsertionAnswer extends ArticleInsertionEvent {
  final bool isCorrect;

  const SubmitArticleInsertionAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextArticleInsertionQuestion extends ArticleInsertionEvent {}

class RestoreArticleInsertionLife extends ArticleInsertionEvent {}

class ArticleInsertionHintUsed extends ArticleInsertionEvent {}
