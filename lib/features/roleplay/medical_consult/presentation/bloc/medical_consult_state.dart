import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/roleplay/medical_consult/domain/entities/medical_consult_quest.dart';

abstract class MedicalConsultState extends Equatable {
  const MedicalConsultState();

  @override
  List<Object?> get props => [];
}

class MedicalConsultInitial extends MedicalConsultState {}

class MedicalConsultLoading extends MedicalConsultState {}

class MedicalConsultLoaded extends MedicalConsultState {
  final List<MedicalConsultQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final int xpEarned;
  final int coinsEarned;

  const MedicalConsultLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.xpEarned = 0,
    this.coinsEarned = 0,
  });

  MedicalConsultQuest get currentQuest => quests[currentIndex];

  MedicalConsultLoaded copyWith({
    List<MedicalConsultQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    int? xpEarned,
    int? coinsEarned,
  }) {
    return MedicalConsultLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      xpEarned: xpEarned ?? this.xpEarned,
      coinsEarned: coinsEarned ?? this.coinsEarned,
    );
  }

  @override
  List<Object?> get props => [
    quests,
    currentIndex,
    livesRemaining,
    lastAnswerCorrect,
    xpEarned,
    coinsEarned,
  ];
}

class MedicalConsultError extends MedicalConsultState {
  final String message;
  const MedicalConsultError(this.message);

  @override
  List<Object?> get props => [message];
}

class MedicalConsultGameComplete extends MedicalConsultState {
  final int xpEarned;
  final int coinsEarned;
  const MedicalConsultGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class MedicalConsultGameOver extends MedicalConsultState {}
