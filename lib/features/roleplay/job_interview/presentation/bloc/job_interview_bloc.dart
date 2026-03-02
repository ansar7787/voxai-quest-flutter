import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/roleplay/job_interview/domain/usecases/get_job_interview_quests.dart';
import 'job_interview_event.dart';
import 'job_interview_state.dart';

class JobInterviewBloc extends Bloc<JobInterviewEvent, JobInterviewState> {
  final GetJobInterviewQuests getQuests;

  JobInterviewBloc({required this.getQuests}) : super(JobInterviewInitial()) {
    on<RestartLevel>((event, emit) => emit(JobInterviewInitial()));
    on<FetchJobInterviewQuests>(_onFetchQuests);
    on<SubmitJobInterviewAnswer>(_onSubmitAnswer);
    on<NextJobInterviewQuestion>(_onNextQuestion);
    on<RestoreJobInterviewLife>(_onRestoreLife);
    on<JobInterviewHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchJobInterviewQuests event,
    Emitter<JobInterviewState> emit,
  ) async {
    emit(JobInterviewLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) =>
          emit(const JobInterviewError("Failed to load job interview quests")),
      (quests) => emit(JobInterviewLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitJobInterviewAnswer event,
    Emitter<JobInterviewState> emit,
  ) {
    final state = this.state;
    if (state is JobInterviewLoaded) {
      final isCorrect = event.isCorrect;
      final newLives = isCorrect
          ? state.livesRemaining
          : state.livesRemaining - 1;

      if (newLives <= 0) {
        emit(JobInterviewGameOver());
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
    NextJobInterviewQuestion event,
    Emitter<JobInterviewState> emit,
  ) {
    final state = this.state;
    if (state is JobInterviewLoaded) {
      if (state.currentIndex + 1 < state.quests.length) {
        emit(
          state.copyWith(
            currentIndex: state.currentIndex + 1,
            lastAnswerCorrect: null,
          ),
        );
      } else {
        emit(
          JobInterviewGameComplete(
            xpEarned: state.xpEarned,
            coinsEarned: state.coinsEarned,
          ),
        );
      }
    }
  }

  void _onRestoreLife(
    RestoreJobInterviewLife event,
    Emitter<JobInterviewState> emit,
  ) {
    final state = this.state;
    if (state is JobInterviewLoaded) {
      emit(state.copyWith(livesRemaining: 3));
    }
  }

  void _onHintUsed(
    JobInterviewHintUsed event,
    Emitter<JobInterviewState> emit,
  ) {
    // Implement hint logic if needed
  }
}
