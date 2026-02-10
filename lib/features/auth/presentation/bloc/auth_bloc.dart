import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';
import 'package:voxai_quest/features/auth/domain/usecases/get_user_stream.dart';
import 'package:voxai_quest/features/auth/domain/usecases/log_out.dart';
import 'package:voxai_quest/features/auth/domain/usecases/reload_user.dart';
import 'package:voxai_quest/features/auth/domain/usecases/get_current_user.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final UserEntity? user;
  const AuthUserChanged(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthReloadUser extends AuthEvent {}

// States
enum AuthStatus { authenticated, unauthenticated, unknown }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;

  const AuthState._({this.status = AuthStatus.unknown, this.user});

  const AuthState.unknown() : this._();

  const AuthState.authenticated(UserEntity user)
    : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user];
}

// BloC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetUserStream _getUserStream;
  final LogOut _logOut;
  final ReloadUser _reloadUser;
  final GetCurrentUser _getCurrentUser;
  late StreamSubscription<UserEntity?> _userSubscription;

  AuthBloc({
    required GetUserStream getUserStream,
    required LogOut logOut,
    required ReloadUser reloadUser,
    required GetCurrentUser getCurrentUser,
  }) : _getUserStream = getUserStream,
       _logOut = logOut,
       _reloadUser = reloadUser,
       _getCurrentUser = getCurrentUser,
       super(const AuthState.unknown()) {
    on<AuthUserChanged>(_onUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthReloadUser>(_onReloadUser);

    _userSubscription = _getUserStream().listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    emit(
      event.user != null
          ? AuthState.authenticated(event.user!)
          : const AuthState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    unawaited(_logOut(NoParams()));
  }

  Future<void> _onReloadUser(
    AuthReloadUser event,
    Emitter<AuthState> emit,
  ) async {
    await _reloadUser(NoParams());
    final result = await _getCurrentUser(NoParams());
    result.fold(
      (failure) => null, // Ignore or handle as needed
      (user) {
        if (user != null) {
          emit(AuthState.authenticated(user));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
