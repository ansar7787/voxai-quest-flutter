import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/auth/domain/usecases/log_in_with_email.dart';
import 'package:voxai_quest/features/auth/domain/usecases/log_in_with_google.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    isSubmitting,
    isSuccess,
    errorMessage,
  ];
}

class LoginCubit extends Cubit<LoginState> {
  final LogInWithEmail _logInWithEmail;
  final LogInWithGoogle _logInWithGoogle;

  LoginCubit({
    required LogInWithEmail logInWithEmail,
    required LogInWithGoogle logInWithGoogle,
  }) : _logInWithEmail = logInWithEmail,
       _logInWithGoogle = logInWithGoogle,
       super(const LoginState());

  void emailChanged(String value) => emit(state.copyWith(email: value));
  void passwordChanged(String value) => emit(state.copyWith(password: value));

  Future<void> logInWithCredentials() async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true));
    final result = await _logInWithEmail(
      LogInParams(email: state.email, password: state.password),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, errorMessage: failure.message),
      ),
      (_) => emit(state.copyWith(isSubmitting: false, isSuccess: true)),
    );
  }

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(isSubmitting: true));
    final result = await _logInWithGoogle(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, errorMessage: failure.message),
      ),
      (_) => emit(state.copyWith(isSubmitting: false, isSuccess: true)),
    );
  }
}
