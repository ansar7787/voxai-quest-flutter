import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/roleplay/conflict_resolver/domain/usecases/get_conflict_resolver_quests.dart';
import 'conflict_resolver_event.dart';
import 'conflict_resolver_state.dart';

class ConflictResolverBloc
    extends Bloc<ConflictResolverEvent, ConflictResolverState> {
  final GetConflictResolverQuests getQuests;

  ConflictResolverBloc({required this.getQuests})
    : super(ConflictResolverInitial()) {
    on<RestartLevel>((event, emit) => emit(ConflictResolverInitial()));
    on<FetchConflictResolverQuests>(_onFetchQuests);
    on<SubmitConflictResolverAnswer>(_onSubmitAnswer);
    on<NextConflictResolverQuestion>(_onNextQuestion);
    on<RestoreConflictResolverLife>(_onRestoreLife);
    on<ConflictResolverHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchConflictResolverQuests event,
    Emitter<ConflictResolverState> emit,
  ) async {
    emit(ConflictResolverLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(
        const ConflictResolverError("Failed to load conflict resolver quests"),
      ),
      (quests) => emit(ConflictResolverLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitConflictResolverAnswer event,
    Emitter<ConflictResolverState> emit,
  ) {
    final state = this.state;
    if (state is ConflictResolverLoaded) {
      final isCorrect = event.isCorrect;
      final newLives = isCorrect
          ? state.livesRemaining
          : state.livesRemaining - 1;

      if (newLives <= 0) {
        emit(ConflictResolverGameOver());
      } else {
        emit(
          state.copyWith(
            livesRemaining: newLives,
            lastAnswerCorrect: isCorrect,
            xpEarned: isCorrect
                ? state.xpEarned + state.currentQuest.xpReward
                : state.xpEarned,
            coinsEarned: isCorrect
                ? state.coinsEarned + state.currentQuest.coinReward
                : state.coinsEarned,
          ),
        );
      }
    }
  }

  void _onNextQuestion(
    NextConflictResolverQuestion event,
    Emitter<ConflictResolverState> emit,
  ) {
    final state = this.state;
    if (state is ConflictResolverLoaded) {
      if (state.currentIndex + 1 < state.quests.length) {
        emit(
          state.copyWith(
            currentIndex: state.currentIndex + 1,
            lastAnswerCorrect: null,
          ),
        );
      } else {
        emit(
          ConflictResolverGameComplete(
            xpEarned: state.xpEarned,
            coinsEarned: state.coinsEarned,
          ),
        );
      }
    }
  }

  void _onRestoreLife(
    RestoreConflictResolverLife event,
    Emitter<ConflictResolverState> emit,
  ) {
    final state = this.state;
    if (state is ConflictResolverLoaded) {
      emit(state.copyWith(livesRemaining: 3));
    }
  }

  void _onHintUsed(
    ConflictResolverHintUsed event,
    Emitter<ConflictResolverState> emit,
  ) {
    // Implement hint logic if needed
  }
}
