import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:voxai_quest/core/utils/haptic_service.dart';
import 'package:voxai_quest/core/utils/sound_service.dart';
import 'package:voxai_quest/features/kids_zone/domain/entities/kids_quest.dart';
import 'package:voxai_quest/features/kids_zone/domain/usecases/get_kids_quests.dart';
import 'package:voxai_quest/features/auth/domain/usecases/update_user_rewards.dart';
import 'package:voxai_quest/features/auth/domain/usecases/update_unlocked_level.dart';
import 'package:voxai_quest/features/auth/domain/usecases/award_kids_sticker.dart';

// Events
abstract class KidsEvent extends Equatable {
  const KidsEvent();
  @override
  List<Object?> get props => [];
}

class FetchKidsQuests extends KidsEvent {
  final String gameType;
  final int level;
  const FetchKidsQuests(this.gameType, this.level);
  @override
  List<Object?> get props => [gameType, level];
}

class SubmitKidsAnswer extends KidsEvent {
  final bool isCorrect;
  const SubmitKidsAnswer(this.isCorrect);
  @override
  List<Object?> get props => [isCorrect];
}

class NextKidsQuestion extends KidsEvent {}

class ClaimDoubleKidsRewards extends KidsEvent {
  final String gameType;
  final int level;
  const ClaimDoubleKidsRewards(this.gameType, this.level);
  @override
  List<Object?> get props => [gameType, level];
}

class ResetKidsGame extends KidsEvent {}

// States
abstract class KidsState extends Equatable {
  const KidsState();
  @override
  List<Object?> get props => [];
}

class KidsInitial extends KidsState {}

class KidsLoading extends KidsState {}

class KidsLoaded extends KidsState {
  final List<KidsQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final String gameType;
  final int level;

  const KidsLoaded({
    required this.quests,
    required this.gameType,
    required this.level,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  KidsQuest get currentQuest => quests[currentIndex];

  KidsLoaded copyWith({
    List<KidsQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    String? gameType,
    int? level,
  }) {
    return KidsLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      gameType: gameType ?? this.gameType,
      level: level ?? this.level,
    );
  }

  @override
  List<Object?> get props => [
    quests,
    currentIndex,
    livesRemaining,
    lastAnswerCorrect,
    gameType,
    level,
  ];
}

class KidsGameComplete extends KidsState {
  final int xpEarned;
  final int coinsEarned;
  final String? stickerAwarded;
  const KidsGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
    this.stickerAwarded,
  });
  @override
  List<Object?> get props => [xpEarned, coinsEarned, stickerAwarded];
}

class KidsGameOver extends KidsState {}

class KidsError extends KidsState {
  final String message;
  const KidsError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class KidsBloc extends Bloc<KidsEvent, KidsState> {
  final GetKidsQuests getKidsQuests;
  final UpdateUserRewards updateUserRewards;
  final UpdateUnlockedLevel updateUnlockedLevel;
  final AwardKidsSticker awardKidsSticker;
  final SoundService soundService;
  final HapticService hapticService;

  KidsBloc({
    required this.getKidsQuests,
    required this.updateUserRewards,
    required this.updateUnlockedLevel,
    required this.awardKidsSticker,
    required this.soundService,
    required this.hapticService,
  }) : super(KidsInitial()) {
    on<FetchKidsQuests>(_onFetchQuests);
    on<SubmitKidsAnswer>(_onSubmitAnswer);
    on<NextKidsQuestion>(_onNextQuestion);
    on<ClaimDoubleKidsRewards>(_onClaimDoubleRewards);
    on<ResetKidsGame>(_onResetGame);
  }

  Future<void> _onFetchQuests(
    FetchKidsQuests event,
    Emitter<KidsState> emit,
  ) async {
    emit(KidsLoading());
    final result = await getKidsQuests(event.gameType, event.level);
    result.fold(
      (failure) =>
          emit(const KidsError('Failed to load quests from Firestore')),
      (quests) {
        // Validation Filter: Discard quests that are missing critical playable data
        final validQuests = quests.where((q) {
          final isMultiChoice = q.gameType == 'choice_multi';
          if (isMultiChoice) {
            return q.correctAnswer != null &&
                q.options != null &&
                q.options!.isNotEmpty;
          }
          return true; // Other game types might have different validation rules
        }).toList();

        if (validQuests.isEmpty) {
          emit(
            const KidsError(
              'No valid quests available for this level. Check Firestore data!',
            ),
          );
        } else {
          emit(
            KidsLoaded(
              quests: validQuests,
              gameType: event.gameType,
              level: event.level,
            ),
          );
        }
      },
    );
  }

  void _onSubmitAnswer(SubmitKidsAnswer event, Emitter<KidsState> emit) {
    if (state is KidsLoaded) {
      final s = state as KidsLoaded;

      if (event.isCorrect) {
        soundService.playCorrect();
        hapticService.success();
      } else {
        soundService.playWrong();
        hapticService.error();
      }

      int newLives = event.isCorrect ? s.livesRemaining : s.livesRemaining - 1;

      if (newLives < 0) {
        emit(KidsGameOver());
      } else {
        emit(
          s.copyWith(
            livesRemaining: newLives,
            lastAnswerCorrect: event.isCorrect,
          ),
        );
      }
    }
  }

  Future<void> _onNextQuestion(
    NextKidsQuestion event,
    Emitter<KidsState> emit,
  ) async {
    if (state is KidsLoaded) {
      final s = state as KidsLoaded;
      int nextIndex = s.currentIndex + 1;

      if (nextIndex >= s.quests.length) {
        // Level Complete
        await updateUserRewards(
          UpdateUserRewardsParams(
            gameType: s.gameType,
            level: s.level,
            xpIncrease: 5,
            coinIncrease: 5,
          ),
        );
        await updateUnlockedLevel(
          UpdateUnlockedLevelParams(
            categoryId: s.gameType,
            newLevel: s.level + 1,
          ),
        );

        String? newSticker;
        if (s.level == 10) {
          newSticker = "sticker_${s.gameType}";
          await awardKidsSticker(newSticker);
        } else if (s.level == 50 ||
            s.level == 100 ||
            s.level == 150 ||
            s.level == 200) {
          newSticker = "${s.gameType}_sticker_${s.level}";
          await awardKidsSticker(newSticker);
        }

        emit(
          KidsGameComplete(
            xpEarned: 5,
            coinsEarned: 5,
            stickerAwarded: newSticker,
          ),
        );
      } else {
        emit(s.copyWith(currentIndex: nextIndex, lastAnswerCorrect: null));
      }
    }
  }

  Future<void> _onClaimDoubleRewards(
    ClaimDoubleKidsRewards event,
    Emitter<KidsState> emit,
  ) async {
    await updateUserRewards(
      UpdateUserRewardsParams(
        gameType: event.gameType,
        level: event.level,
        xpIncrease: 5,
        coinIncrease: 5,
      ),
    );
  }

  void _onResetGame(ResetKidsGame event, Emitter<KidsState> emit) {
    emit(KidsInitial());
  }
}
