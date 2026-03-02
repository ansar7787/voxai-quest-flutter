import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/grammar/subject_verb_agreement/domain/usecases/get_subject_verb_agreement_quests.dart';
import 'subject_verb_agreement_event.dart';
import 'subject_verb_agreement_state.dart';

class SubjectVerbAgreementBloc extends Bloc<SubjectVerbAgreementEvent, SubjectVerbAgreementState> {
  final GetSubjectVerbAgreementQuests getQuests;

  SubjectVerbAgreementBloc({required this.getQuests}) : super(SubjectVerbAgreementInitial()) {
    on<FetchSubjectVerbAgreementQuests>(_onFetchQuests);
    on<SubmitSubjectVerbAgreementAnswer>(_onSubmitAnswer);
    on<NextSubjectVerbAgreementQuestion>(_onNextQuestion);
    on<RestoreSubjectVerbAgreementLife>(_onRestoreLife);
    on<SubjectVerbAgreementHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchSubjectVerbAgreementQuests event,
    Emitter<SubjectVerbAgreementState> emit,
  ) async {
    emit(SubjectVerbAgreementLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(SubjectVerbAgreementError(failure.message)),
      (quests) => emit(SubjectVerbAgreementLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitSubjectVerbAgreementAnswer event,
    Emitter<SubjectVerbAgreementState> emit,
  ) {
    final state = this.state;
    if (state is SubjectVerbAgreementLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(SubjectVerbAgreementGameOver());
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
    NextSubjectVerbAgreementQuestion event,
    Emitter<SubjectVerbAgreementState> emit,
  ) {
    final state = this.state;
    if (state is SubjectVerbAgreementLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(SubjectVerbAgreementGameComplete(
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
    RestoreSubjectVerbAgreementLife event,
    Emitter<SubjectVerbAgreementState> emit,
  ) {
    emit(SubjectVerbAgreementInitial());
  }

  void _onHintUsed(
    SubjectVerbAgreementHintUsed event,
    Emitter<SubjectVerbAgreementState> emit,
  ) {
    final state = this.state;
    if (state is SubjectVerbAgreementLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
