import 'package:equatable/equatable.dart';

abstract class PrefixSuffixEvent extends Equatable {
  const PrefixSuffixEvent();

  @override
  List<Object?> get props => [];
}

class FetchPrefixSuffixQuests extends PrefixSuffixEvent {
  final int level;

  const FetchPrefixSuffixQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitPrefixSuffixAnswer extends PrefixSuffixEvent {
  final bool isCorrect;

  const SubmitPrefixSuffixAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextPrefixSuffixQuestion extends PrefixSuffixEvent {}

class RestorePrefixSuffixLife extends PrefixSuffixEvent {}

class PrefixSuffixHintUsed extends PrefixSuffixEvent {}
