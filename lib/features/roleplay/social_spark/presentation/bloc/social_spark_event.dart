import 'package:equatable/equatable.dart';

abstract class SocialSparkEvent extends Equatable {
  const SocialSparkEvent();

  @override
  List<Object?> get props => [];
}

class FetchSocialSparkQuests extends SocialSparkEvent {
  final int level;
  const FetchSocialSparkQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitSocialSparkAnswer extends SocialSparkEvent {
  final bool isCorrect;
  const SubmitSocialSparkAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextSocialSparkQuestion extends SocialSparkEvent {}

class RestoreSocialSparkLife extends SocialSparkEvent {}

class SocialSparkHintUsed extends SocialSparkEvent {}


class RestartLevel extends SocialSparkEvent {}

