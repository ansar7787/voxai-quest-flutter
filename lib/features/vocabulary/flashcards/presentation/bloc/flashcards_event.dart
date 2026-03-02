import 'package:equatable/equatable.dart';

abstract class FlashcardsEvent extends Equatable {
  const FlashcardsEvent();

  @override
  List<Object?> get props => [];
}

class FetchFlashcardsQuests extends FlashcardsEvent {
  final int level;

  const FetchFlashcardsQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitFlashcardsAnswer extends FlashcardsEvent {
  final bool isCorrect;

  const SubmitFlashcardsAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextFlashcardsQuestion extends FlashcardsEvent {}

class RestoreFlashcardsLife extends FlashcardsEvent {}

class FlashcardsHintUsed extends FlashcardsEvent {}
