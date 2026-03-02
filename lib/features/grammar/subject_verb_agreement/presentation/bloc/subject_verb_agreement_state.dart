import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/grammar/subject_verb_agreement/domain/entities/subject_verb_agreement_quest.dart';

abstract class SubjectVerbAgreementState extends Equatable {
  const SubjectVerbAgreementState();

  @override
  List<Object?> get props => [];
}

class SubjectVerbAgreementInitial extends SubjectVerbAgreementState {}

class SubjectVerbAgreementLoading extends SubjectVerbAgreementState {}

class SubjectVerbAgreementLoaded extends SubjectVerbAgreementState {
  final List<SubjectVerbAgreementQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const SubjectVerbAgreementLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  SubjectVerbAgreementQuest get currentQuest => quests[currentIndex];

  SubjectVerbAgreementLoaded copyWith({
    List<SubjectVerbAgreementQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return SubjectVerbAgreementLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      hintUsed: hintUsed ?? this.hintUsed,
    );
  }

  @override
  List<Object?> get props => [quests, currentIndex, livesRemaining, lastAnswerCorrect, hintUsed];
}

class SubjectVerbAgreementGameComplete extends SubjectVerbAgreementState {
  final int xpEarned;
  final int coinsEarned;

  const SubjectVerbAgreementGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class SubjectVerbAgreementGameOver extends SubjectVerbAgreementState {}

class SubjectVerbAgreementError extends SubjectVerbAgreementState {
  final String message;

  const SubjectVerbAgreementError(this.message);

  @override
  List<Object?> get props => [message];
}
