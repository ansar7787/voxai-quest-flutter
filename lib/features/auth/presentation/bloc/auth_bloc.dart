import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';
import 'package:voxai_quest/features/auth/domain/usecases/get_user_stream.dart';
import 'package:voxai_quest/features/auth/domain/usecases/log_out.dart';
import 'package:voxai_quest/features/auth/domain/usecases/reload_user.dart';
import 'package:voxai_quest/features/auth/domain/usecases/get_current_user.dart';
import 'package:voxai_quest/features/auth/domain/usecases/update_user.dart';
import 'package:voxai_quest/features/auth/domain/usecases/claim_vip_gift.dart';
import 'package:voxai_quest/features/auth/domain/usecases/purchase_hint.dart';
import 'package:voxai_quest/features/auth/domain/usecases/update_user_coins.dart';
import 'package:voxai_quest/features/auth/domain/usecases/update_profile_picture.dart';
import 'package:voxai_quest/features/auth/domain/usecases/update_display_name.dart';
import 'package:voxai_quest/features/auth/domain/usecases/update_kids_mascot.dart';
import 'package:voxai_quest/features/auth/domain/usecases/buy_kids_accessory.dart';
import 'package:voxai_quest/features/auth/domain/usecases/equip_kids_accessory.dart';
import 'package:voxai_quest/features/auth/domain/usecases/repair_streak.dart';
import 'package:voxai_quest/features/auth/domain/usecases/purchase_streak_freeze.dart';
import 'package:voxai_quest/features/auth/domain/usecases/activate_double_xp.dart';
import 'package:voxai_quest/features/auth/domain/usecases/delete_account.dart';
import 'package:voxai_quest/features/auth/domain/usecases/forgot_password.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/core/network/network_info.dart';

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

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthReloadUser extends AuthEvent {
  const AuthReloadUser();
}

class AuthDeleteAccountRequested extends AuthEvent {
  const AuthDeleteAccountRequested();
}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;
  const AuthPasswordResetRequested(this.email);
  @override
  List<Object?> get props => [email];
}

class AuthUpdateUser extends AuthEvent {
  final UserEntity user;
  const AuthUpdateUser(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthClaimVipGiftRequested extends AuthEvent {
  const AuthClaimVipGiftRequested();
}

class AuthPurchaseHintRequested extends AuthEvent {
  final int cost;
  final int hintAmount;
  const AuthPurchaseHintRequested(this.cost, {this.hintAmount = 1});
  @override
  List<Object?> get props => [cost, hintAmount];
}

class AuthAddCoinsRequested extends AuthEvent {
  final int amount;
  final String title;
  final bool isEarned;

  const AuthAddCoinsRequested(
    this.amount, {
    this.title = 'Earned Coins',
    this.isEarned = true,
  });

  @override
  List<Object?> get props => [amount, title, isEarned];
}

class AuthUpdateProfilePictureRequested extends AuthEvent {
  final String filePath;
  const AuthUpdateProfilePictureRequested(this.filePath);
  @override
  List<Object?> get props => [filePath];
}

class AuthUpdateDisplayNameRequested extends AuthEvent {
  final String displayName;
  const AuthUpdateDisplayNameRequested(this.displayName);
  @override
  List<Object?> get props => [displayName];
}

class AuthConsumeHintRequested extends AuthEvent {
  const AuthConsumeHintRequested();
}

class AuthUpdateKidsMascotRequested extends AuthEvent {
  final String mascotId;
  const AuthUpdateKidsMascotRequested(this.mascotId);
  @override
  List<Object?> get props => [mascotId];
}

class AuthBuyKidsAccessoryRequested extends AuthEvent {
  final String accessoryId;
  final int cost;
  const AuthBuyKidsAccessoryRequested(this.accessoryId, this.cost);
  @override
  List<Object?> get props => [accessoryId, cost];
}

class AuthEquipKidsAccessoryRequested extends AuthEvent {
  final String? accessoryId;
  const AuthEquipKidsAccessoryRequested(this.accessoryId);
  @override
  List<Object?> get props => [accessoryId];
}

class AuthUpdateVoxinMascotRequested extends AuthEvent {
  final String mascotId;
  const AuthUpdateVoxinMascotRequested(this.mascotId);
  @override
  List<Object?> get props => [mascotId];
}

class AuthBuyVoxinAccessoryRequested extends AuthEvent {
  final String accessoryId;
  final int cost;
  const AuthBuyVoxinAccessoryRequested(this.accessoryId, this.cost);
  @override
  List<Object?> get props => [accessoryId, cost];
}

class AuthEquipVoxinAccessoryRequested extends AuthEvent {
  final String? accessoryId;
  const AuthEquipVoxinAccessoryRequested(this.accessoryId);
  @override
  List<Object?> get props => [accessoryId];
}

class AuthAddKidsCoinsRequested extends AuthEvent {
  final int amount;
  const AuthAddKidsCoinsRequested(this.amount);
  @override
  List<Object?> get props => [amount];
}

class AuthRepairStreakRequested extends AuthEvent {
  final int cost;
  const AuthRepairStreakRequested(this.cost);
  @override
  List<Object?> get props => [cost];
}

class AuthPurchaseStreakFreezeRequested extends AuthEvent {
  final int cost;
  const AuthPurchaseStreakFreezeRequested(this.cost);
  @override
  List<Object?> get props => [cost];
}

class AuthActivateDoubleXPRequested extends AuthEvent {
  final int cost;
  const AuthActivateDoubleXPRequested(this.cost);
  @override
  List<Object?> get props => [cost];
}

class AuthClaimStreakMilestoneRequested extends AuthEvent {
  final int milestone;
  final int reward;
  const AuthClaimStreakMilestoneRequested(this.milestone, this.reward);
  @override
  List<Object?> get props => [milestone, reward];
}

class AuthClaimLevelMilestoneRequested extends AuthEvent {
  final int milestone;
  final int reward;
  const AuthClaimLevelMilestoneRequested(this.milestone, this.reward);
  @override
  List<Object?> get props => [milestone, reward];
}

class AuthClaimDailyChestRequested extends AuthEvent {
  final int amount;
  const AuthClaimDailyChestRequested(this.amount);
  @override
  List<Object?> get props => [amount];
}

class AuthPurchaseXPBoostRequested extends AuthEvent {
  final String type;
  final int cost;
  final String title;

  const AuthPurchaseXPBoostRequested({
    required this.type,
    required this.cost,
    required this.title,
  });

  @override
  List<Object?> get props => [type, cost, title];
}

class AuthClearPurchaseFeedback extends AuthEvent {
  const AuthClearPurchaseFeedback();
}

// States
enum AuthStatus { authenticated, unauthenticated, unknown }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? message;
  final String? lastPurchaseType;
  final bool? lastPurchaseSuccess;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user,
    this.message,
    this.lastPurchaseType,
    this.lastPurchaseSuccess,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(
    UserEntity user, {
    String? message,
    String? lastPurchaseType,
    bool? lastPurchaseSuccess,
  }) : this._(
         status: AuthStatus.authenticated,
         user: user,
         message: message,
         lastPurchaseType: lastPurchaseType,
         lastPurchaseSuccess: lastPurchaseSuccess,
       );

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [
    status,
    user,
    message,
    lastPurchaseType,
    lastPurchaseSuccess,
  ];

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? message,
    String? lastPurchaseType,
    bool? lastPurchaseSuccess,
  }) {
    return AuthState._(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
      lastPurchaseType: lastPurchaseType ?? this.lastPurchaseType,
      lastPurchaseSuccess: lastPurchaseSuccess ?? this.lastPurchaseSuccess,
    );
  }
}

// BloC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetUserStream _getUserStream;
  final LogOut _logOut;
  final ReloadUser _reloadUser;
  final GetCurrentUser _getCurrentUser;
  final UpdateUser _updateUser;
  final ClaimVipGift _claimVipGift;
  final PurchaseHint _purchaseHint;
  final UpdateUserCoins _updateUserCoins;
  final UpdateProfilePicture _updateProfilePicture;
  final UpdateDisplayName _updateDisplayName;
  final UpdateKidsMascot _updateKidsMascot;
  final BuyKidsAccessory _buyKidsAccessory;
  final EquipKidsAccessory _equipKidsAccessory;
  final RepairStreak _repairStreak;
  final PurchaseStreakFreeze _purchaseStreakFreeze;
  final ActivateDoubleXP _activateDoubleXP;
  final DeleteAccount _deleteAccount;
  final ForgotPassword _forgotPassword;
  final NetworkInfo? _networkInfo;
  late StreamSubscription<UserEntity?> _userSubscription;

  AuthBloc({
    required GetUserStream getUserStream,
    required LogOut logOut,
    required ReloadUser reloadUser,
    required GetCurrentUser getCurrentUser,
    required UpdateUser updateUser,
    required ClaimVipGift claimVipGift,
    required PurchaseHint purchaseHint,
    required UpdateUserCoins updateUserCoins,
    required UpdateProfilePicture updateProfilePicture,
    required UpdateDisplayName updateDisplayName,
    required UpdateKidsMascot updateKidsMascot,
    required BuyKidsAccessory buyKidsAccessory,
    required EquipKidsAccessory equipKidsAccessory,
    required RepairStreak repairStreak,
    required PurchaseStreakFreeze purchaseStreakFreeze,
    required ActivateDoubleXP activateDoubleXP,
    required DeleteAccount deleteAccount,
    required ForgotPassword forgotPassword,
    NetworkInfo? networkInfo,
  }) : _getUserStream = getUserStream,
       _logOut = logOut,
       _reloadUser = reloadUser,
       _getCurrentUser = getCurrentUser,
       _updateUser = updateUser,
       _claimVipGift = claimVipGift,
       _purchaseHint = purchaseHint,
       _updateUserCoins = updateUserCoins,
       _updateProfilePicture = updateProfilePicture,
       _updateDisplayName = updateDisplayName,
       _updateKidsMascot = updateKidsMascot,
       _buyKidsAccessory = buyKidsAccessory,
       _equipKidsAccessory = equipKidsAccessory,
       _repairStreak = repairStreak,
       _purchaseStreakFreeze = purchaseStreakFreeze,
       _activateDoubleXP = activateDoubleXP,
       _deleteAccount = deleteAccount,
       _forgotPassword = forgotPassword,
       _networkInfo = networkInfo,
       super(const AuthState.unknown()) {
    on<AuthUserChanged>(_onUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthReloadUser>(_onReloadUser);
    on<AuthDeleteAccountRequested>(_onDeleteAccountRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthUpdateUser>(_onUpdateUser);
    on<AuthClaimVipGiftRequested>(_onClaimVipGiftRequested);
    on<AuthPurchaseHintRequested>(_onPurchaseHintRequested);
    on<AuthAddCoinsRequested>(_onAddCoinsRequested);
    on<AuthUpdateProfilePictureRequested>(_onUpdateProfilePictureRequested);
    on<AuthUpdateDisplayNameRequested>(_onUpdateDisplayNameRequested);
    on<AuthPurchaseXPBoostRequested>(_onPurchaseXPBoostRequested);
    on<AuthConsumeHintRequested>(_onConsumeHintRequested);
    on<AuthUpdateKidsMascotRequested>(_onUpdateKidsMascotRequested);
    on<AuthBuyKidsAccessoryRequested>(_onBuyKidsAccessoryRequested);
    on<AuthEquipKidsAccessoryRequested>(_onEquipKidsAccessoryRequested);
    on<AuthAddKidsCoinsRequested>(_onAddKidsCoinsRequested);
    on<AuthRepairStreakRequested>(_onRepairStreakRequested);
    on<AuthPurchaseStreakFreezeRequested>(_onPurchaseStreakFreezeRequested);
    on<AuthActivateDoubleXPRequested>(_onActivateDoubleXPRequested);
    on<AuthClaimStreakMilestoneRequested>(_onClaimStreakMilestoneRequested);
    on<AuthClaimLevelMilestoneRequested>(_onClaimLevelMilestoneRequested);
    on<AuthClaimDailyChestRequested>(_onClaimDailyChestRequested);
    on<AuthUpdateVoxinMascotRequested>(_onUpdateVoxinMascotRequested);
    on<AuthBuyVoxinAccessoryRequested>(_onBuyVoxinAccessoryRequested);
    on<AuthEquipVoxinAccessoryRequested>(_onEquipVoxinAccessoryRequested);
    on<AuthClearPurchaseFeedback>(_onClearPurchaseFeedback);

    _userSubscription = _getUserStream().listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  Future<void> _onUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user != null) {
      final user = event.user!;
      final now = DateTime.now();
      final lastLogin = user.lastLoginDate;

      if (lastLogin != null) {
        final difference = now.difference(lastLogin).inDays;
        final isSameDay =
            now.year == lastLogin.year &&
            now.month == lastLogin.month &&
            now.day == lastLogin.day;

        if (!isSameDay && difference <= 1) {
          // Consecutive Day - Increment Streak
          final updatedUser = user.copyWith(
            currentStreak: user.currentStreak + 1,
            lastLoginDate: now,
          );
          await _updateUser(UpdateUserParams(user: updatedUser));
          emit(AuthState.authenticated(updatedUser));
        } else if (!isSameDay && difference > 1) {
          if (user.streakFreezes > 0 || user.level >= 50) {
            // Consume freeze or use Level 50+ Protection (streak remains the same)
            final updatedUser = user.copyWith(
              streakFreezes: user.level >= 50
                  ? user.streakFreezes
                  : user.streakFreezes - 1,
              lastLoginDate: now,
            );
            await _updateUser(UpdateUserParams(user: updatedUser));
            emit(AuthState.authenticated(updatedUser));
          } else {
            // Reset streak
            final updatedUser = user.copyWith(
              currentStreak: 1, // Start a new streak today
              lastLoginDate: now,
            );
            await _updateUser(UpdateUserParams(user: updatedUser));
            emit(AuthState.authenticated(updatedUser));
          }
        } else {
          // Same day or some other case, just emit current user
          emit(AuthState.authenticated(user));
        }
      } else {
        // First ever login - initialize streak
        final updatedUser = user.copyWith(currentStreak: 1, lastLoginDate: now);
        await _updateUser(UpdateUserParams(user: updatedUser));
        emit(AuthState.authenticated(updatedUser));
      }
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onUpdateUser(
    AuthUpdateUser event,
    Emitter<AuthState> emit,
  ) async {
    // Persist the user update (e.g. inventory changes from shop)
    final result = await _updateUser(UpdateUserParams(user: event.user));
    result.fold((failure) {
      // Handle failure? Maybe revert state or show error?
      // For now, keep current state or ideally emit an error state side-effect.
      // We will just emit the optimistic update or let the stream handle it.
      // But since we already have the event.user, let's emit it to update UI immediately.
    }, (_) => emit(AuthState.authenticated(event.user)));
    // Note: The stream from Listen might also trigger _onUserChanged with the new data.
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    unawaited(_logOut(NoParams()));
  }

  Future<void> _onDeleteAccountRequested(
    AuthDeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _deleteAccount(NoParams());
    result.fold(
      (failure) {
        emit(state.copyWith(message: failure.message));
        emit(state.copyWith(message: null));
      },
      (_) => null, // State will change to unauthenticated automatically
    );
  }

  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _forgotPassword(event.email);
    result.fold(
      (failure) {
        emit(state.copyWith(message: failure.message));
        emit(state.copyWith(message: null));
      },
      (_) {
        emit(state.copyWith(message: 'Password reset email sent!'));
        emit(state.copyWith(message: null));
      },
    );
  }

  Future<void> _onReloadUser(
    AuthReloadUser event,
    Emitter<AuthState> emit,
  ) async {
    if (_networkInfo != null) {
      if (!(await _networkInfo.isConnected)) {
        return; // Stay in current state if offline
      }
    }
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

  Future<void> _onClaimVipGiftRequested(
    AuthClaimVipGiftRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_networkInfo != null && !(await _networkInfo.isConnected)) return;
    final result = await _claimVipGift(NoParams());
    result.fold((failure) {}, (_) => add(AuthReloadUser()));
  }

  Future<void> _onPurchaseHintRequested(
    AuthPurchaseHintRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      if (_networkInfo != null && !(await _networkInfo.isConnected)) return;
      final currentUser = state.user!;
      if (currentUser.coins >= event.cost) {
        // Optimistic Update
        final newHistory = _addCoinHistoryEntry(
          currentUser.coinHistory,
          title: event.hintAmount > 1
              ? 'Purchased Hint Pack'
              : 'Purchased Hint',
          amount: -event.cost,
          isEarned: false,
        );
        final updatedUser = currentUser.copyWith(
          coins: currentUser.coins - event.cost,
          hintCount: currentUser.hintCount + event.hintAmount,
          coinHistory: newHistory,
        );
        emit(AuthState.authenticated(updatedUser));

        final result = await _purchaseHint(
          PurchaseHintParams(cost: event.cost, hintAmount: event.hintAmount),
        );
        result.fold(
          (failure) {
            // Revert on failure
            emit(AuthState.authenticated(currentUser));
          },
          (_) {
            // Success - mostly redundant to reload here if optimistic worked,
            // but good for sync.
            // We can skip reload if we trust the optimistic update,
            // or do it silently.
          },
        );
      }
    }
  }

  Future<void> _onAddCoinsRequested(
    AuthAddCoinsRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      // Optimistic Update
      final newHistory = _addCoinHistoryEntry(
        currentUser.coinHistory,
        title: event.title,
        amount: event.amount,
        isEarned: event.isEarned,
      );
      final updatedUser = currentUser.copyWith(
        coins: currentUser.coins + event.amount,
        coinHistory: newHistory,
      );
      emit(AuthState.authenticated(updatedUser));

      final result = await _updateUserCoins(
        UpdateUserCoinsParams(
          amountChange: event.amount,
          title: event.title,
          isEarned: event.isEarned,
        ),
      );
      result.fold((failure) {
        emit(AuthState.authenticated(currentUser));
      }, (_) {});
    }
  }

  Future<void> _onUpdateProfilePictureRequested(
    AuthUpdateProfilePictureRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_networkInfo != null && !(await _networkInfo.isConnected)) return;
    final result = await _updateProfilePicture(event.filePath);
    result.fold(
      (failure) {
        // Handle failure if needed
      },
      (newPhotoUrl) {
        add(AuthReloadUser());
      },
    );
  }

  Future<void> _onUpdateDisplayNameRequested(
    AuthUpdateDisplayNameRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_networkInfo != null && !(await _networkInfo.isConnected)) return;
    final result = await _updateDisplayName(event.displayName);
    result.fold(
      (failure) {
        // Handle failure
      },
      (_) {
        add(AuthReloadUser());
      },
    );
  }

  Future<void> _onConsumeHintRequested(
    AuthConsumeHintRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null && state.user!.hintCount > 0) {
      final currentUser = state.user!;
      // Optimistic Update
      final updatedUser = currentUser.copyWith(
        hintCount: currentUser.hintCount - 1,
      );
      emit(AuthState.authenticated(updatedUser));

      // Persist to Firestore
      final result = await _updateUser(UpdateUserParams(user: updatedUser));
      result.fold((failure) {
        // Revert on failure
        emit(AuthState.authenticated(currentUser));
      }, (_) => null);
    }
  }

  Future<void> _onUpdateKidsMascotRequested(
    AuthUpdateKidsMascotRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      // Optimistic Update
      final updatedUser = currentUser.copyWith(kidsMascot: event.mascotId);
      emit(AuthState.authenticated(updatedUser));

      final result = await _updateKidsMascot(event.mascotId);
      result.fold((failure) {
        // Revert on failure
        emit(AuthState.authenticated(currentUser));
      }, (_) => null);
    }
  }

  Future<void> _onBuyKidsAccessoryRequested(
    AuthBuyKidsAccessoryRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      if (currentUser.kidsCoins < event.cost) return;

      // Optimistic Update
      final updatedOwned = List<String>.from(currentUser.kidsOwnedAccessories);
      if (!updatedOwned.contains(event.accessoryId)) {
        updatedOwned.add(event.accessoryId);
      }
      final updatedUser = currentUser.copyWith(
        kidsCoins: currentUser.kidsCoins - event.cost,
        kidsOwnedAccessories: updatedOwned,
      );
      emit(AuthState.authenticated(updatedUser));

      final result = await _buyKidsAccessory(
        BuyKidsAccessoryParams(
          accessoryId: event.accessoryId,
          cost: event.cost,
        ),
      );
      result.fold((failure) {
        // Revert on failure
        emit(AuthState.authenticated(currentUser));
      }, (_) => null);
    }
  }

  Future<void> _onEquipKidsAccessoryRequested(
    AuthEquipKidsAccessoryRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      // Optimistic Update
      final updatedUser = currentUser.copyWith(
        kidsEquippedAccessory: event.accessoryId,
      );
      emit(AuthState.authenticated(updatedUser));

      final result = await _equipKidsAccessory(event.accessoryId);
      result.fold((failure) {
        // Revert on failure
        emit(AuthState.authenticated(currentUser));
      }, (_) => null);
    }
  }

  Future<void> _onAddKidsCoinsRequested(
    AuthAddKidsCoinsRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      final updatedUser = currentUser.copyWith(
        kidsCoins: currentUser.kidsCoins + event.amount,
      );
      emit(AuthState.authenticated(updatedUser));

      // We use the same update logic but the repository handles kidsCoins if we pass isKidsGame: true
      // (Assuming the repository/usecase holds this logic as seen in grep)
      // For now, let's just use the direct Firestore update if available or a generic update
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.id)
          .update({'kidsCoins': FieldValue.increment(event.amount)});
    }
  }

  Future<void> _onUpdateVoxinMascotRequested(
    AuthUpdateVoxinMascotRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      final updatedUser = currentUser.copyWith(voxinMascot: event.mascotId);
      final result = await _updateUser(UpdateUserParams(user: updatedUser));
      result.fold(
        (failure) => emit(
          state.copyWith(
            lastPurchaseType: 'voxin_mascot',
            lastPurchaseSuccess: false,
            message: failure.message,
          ),
        ),
        (_) => emit(
          AuthState.authenticated(
            updatedUser,
            lastPurchaseType: 'voxin_mascot',
            lastPurchaseSuccess: true,
          ),
        ),
      );
    }
  }

  Future<void> _onBuyVoxinAccessoryRequested(
    AuthBuyVoxinAccessoryRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      if (currentUser.coins < event.cost) return;

      final updatedOwned = List<String>.from(currentUser.voxinOwnedAccessories);
      if (!updatedOwned.contains(event.accessoryId)) {
        updatedOwned.add(event.accessoryId);
      }

      final newHistory = _addCoinHistoryEntry(
        currentUser.coinHistory,
        title: 'Bought Voxin Accessory',
        amount: -event.cost,
        isEarned: false,
      );

      final updatedUser = currentUser.copyWith(
        coins: currentUser.coins - event.cost,
        voxinOwnedAccessories: updatedOwned,
        coinHistory: newHistory,
      );
      final result = await _updateUser(UpdateUserParams(user: updatedUser));
      result.fold(
        (failure) => emit(
          state.copyWith(
            lastPurchaseType: 'voxin_accessory',
            lastPurchaseSuccess: false,
            message: failure.message,
          ),
        ),
        (_) => emit(
          AuthState.authenticated(
            updatedUser,
            lastPurchaseType: 'voxin_accessory',
            lastPurchaseSuccess: true,
          ),
        ),
      );
    }
  }

  Future<void> _onEquipVoxinAccessoryRequested(
    AuthEquipVoxinAccessoryRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      final updatedUser = currentUser.copyWith(
        voxinEquippedAccessory: event.accessoryId,
      );
      final result = await _updateUser(UpdateUserParams(user: updatedUser));
      result.fold(
        (failure) => emit(
          state.copyWith(
            lastPurchaseType: 'voxin_equip',
            lastPurchaseSuccess: false,
            message: failure.message,
          ),
        ),
        (_) => emit(
          AuthState.authenticated(
            updatedUser,
            lastPurchaseType: 'voxin_equip',
            lastPurchaseSuccess: true,
          ),
        ),
      );
    }
  }

  Future<void> _onRepairStreakRequested(
    AuthRepairStreakRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      if (currentUser.coins < event.cost) return;

      // Optimistic Update: Assume repair sets streak back to what it was + 1
      final newStreak = currentUser.currentStreak == 1
          ? 2
          : currentUser.currentStreak + 1;

      final newHistory = _addCoinHistoryEntry(
        currentUser.coinHistory,
        title: 'Repaired Streak',
        amount: -event.cost,
        isEarned: false,
      );

      final updatedUser = currentUser.copyWith(
        coins: currentUser.coins - event.cost,
        currentStreak: newStreak,
        coinHistory: newHistory,
      );
      emit(AuthState.authenticated(updatedUser));

      final result = await _repairStreak(event.cost);
      result.fold((failure) {
        emit(AuthState.authenticated(currentUser));
      }, (_) => null);
    }
  }

  Future<void> _onPurchaseStreakFreezeRequested(
    AuthPurchaseStreakFreezeRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      if (currentUser.coins < event.cost) return;

      // Optimistic Update
      final newHistory = _addCoinHistoryEntry(
        currentUser.coinHistory,
        title: 'Purchased Streak Freeze',
        amount: -event.cost,
        isEarned: false,
      );

      final updatedUser = currentUser.copyWith(
        coins: currentUser.coins - event.cost,
        streakFreezes: currentUser.streakFreezes + 1,
        coinHistory: newHistory,
      );
      emit(AuthState.authenticated(updatedUser));

      final result = await _purchaseStreakFreeze(event.cost);
      result.fold((failure) {
        emit(AuthState.authenticated(currentUser));
      }, (_) => null);
    }
  }

  Future<void> _onActivateDoubleXPRequested(
    AuthActivateDoubleXPRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      if (currentUser.coins < event.cost) return;

      // Optimistic Update
      final expiry = DateTime.now().add(const Duration(hours: 24));

      final newHistory = _addCoinHistoryEntry(
        currentUser.coinHistory,
        title: 'Purchased Double XP',
        amount: -event.cost,
        isEarned: false,
      );

      final updatedUser = currentUser.copyWith(
        coins: currentUser.coins - event.cost,
        doubleXP: 1,
        doubleXPExpiry: expiry,
        coinHistory: newHistory,
      );
      emit(AuthState.authenticated(updatedUser));

      final result = await _activateDoubleXP(event.cost);
      result.fold((failure) {
        emit(AuthState.authenticated(currentUser));
      }, (_) => null);
    }
  }

  Future<void> _onClaimStreakMilestoneRequested(
    AuthClaimStreakMilestoneRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      if (currentUser.claimedStreakMilestones.contains(event.milestone)) return;
      if (currentUser.currentStreak < event.milestone) return;

      final updatedMilestones = List<int>.from(
        currentUser.claimedStreakMilestones,
      )..add(event.milestone);

      final newHistory = _addCoinHistoryEntry(
        currentUser.coinHistory,
        title: 'Streak Milestone Reward',
        amount: event.reward,
        isEarned: true,
      );

      final updatedUser = currentUser.copyWith(
        coins: currentUser.coins + event.reward,
        claimedStreakMilestones: updatedMilestones,
        coinHistory: newHistory,
      );

      emit(AuthState.authenticated(updatedUser));

      final result = await _updateUser(UpdateUserParams(user: updatedUser));
      result.fold((failure) {
        emit(AuthState.authenticated(currentUser));
      }, (_) => null);
    }
  }

  Future<void> _onClaimLevelMilestoneRequested(
    AuthClaimLevelMilestoneRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      if (currentUser.claimedLevelMilestones.contains(event.milestone)) return;
      if (currentUser.level < event.milestone) return;

      final updatedMilestones = List<int>.from(
        currentUser.claimedLevelMilestones,
      )..add(event.milestone);

      final newHistory = _addCoinHistoryEntry(
        currentUser.coinHistory,
        title: 'Level ${event.milestone} Milestone Reward',
        amount: event.reward,
        isEarned: true,
      );

      final updatedUser = currentUser.copyWith(
        coins: currentUser.coins + event.reward,
        claimedLevelMilestones: updatedMilestones,
        coinHistory: newHistory,
      );

      emit(AuthState.authenticated(updatedUser));

      final result = await _updateUser(UpdateUserParams(user: updatedUser));
      result.fold((failure) {
        emit(AuthState.authenticated(currentUser));
      }, (_) => null);
    }
  }

  Future<void> _onClaimDailyChestRequested(
    AuthClaimDailyChestRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      final now = DateTime.now();

      // Optimistic Update
      final newHistory = _addCoinHistoryEntry(
        currentUser.coinHistory,
        title: 'Daily Mystery Chest Reward',
        amount: event.amount,
        isEarned: true,
      );

      final updatedUser = currentUser.copyWith(
        coins: currentUser.coins + event.amount,
        lastDailyRewardDate: now,
        coinHistory: newHistory,
      );

      emit(AuthState.authenticated(updatedUser));

      final result = await _updateUser(UpdateUserParams(user: updatedUser));
      result.fold((failure) {
        // Revert on failure
        emit(AuthState.authenticated(currentUser));
      }, (_) => null);
    }
  }

  /// Helper to maintain a max of 10 history entries
  List<Map<String, dynamic>> _addCoinHistoryEntry(
    List<Map<String, dynamic>> currentHistory, {
    required String title,
    required int amount,
    required bool isEarned,
  }) {
    final entry = {
      'title': title,
      'amount': amount,
      'isEarned': isEarned,
      'date': DateTime.now().toIso8601String(),
    };

    final newHistory = List<Map<String, dynamic>>.from(currentHistory);
    newHistory.insert(0, entry);
    if (newHistory.length > 10) {
      newHistory.removeLast();
    }
    return newHistory;
  }

  Future<void> _onPurchaseXPBoostRequested(
    AuthPurchaseXPBoostRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state.user != null) {
      final currentUser = state.user!;
      if (currentUser.coins < event.cost) {
        emit(
          state.copyWith(
            message: 'Not enough coins',
            lastPurchaseType: event.type,
            lastPurchaseSuccess: false,
          ),
        );
        // Reset after 2 seconds for UI feedback
        Future.delayed(const Duration(seconds: 2), () {
          if (!isClosed) {
            add(const AuthClearPurchaseFeedback());
          }
        });
        return;
      }

      int updatedXP = currentUser.totalExp;
      int updatedDoubleXP = currentUser.doubleXP;
      DateTime? updatedDoubleXPExpiry = currentUser.doubleXPExpiry;
      bool updatedPermanentBoost = currentUser.hasPermanentXPBoost;
      int updatedStreakFreezes = currentUser.streakFreezes;
      final updatedActivities = List<Map<String, dynamic>>.from(
        currentUser.recentActivities,
      );
      final updatedDailyHistory = Map<String, int>.from(
        currentUser.dailyXpHistory,
      );

      String activitySubtitle = '';

      if (event.type == 'shield') {
        updatedStreakFreezes += 1;
        activitySubtitle = 'Shielded! +1 Streak Freeze';
      } else if (event.type == 'warp') {
        updatedDoubleXP = 1;
        updatedDoubleXPExpiry = DateTime.now().add(const Duration(hours: 1));
        activitySubtitle = '2x Multiplier Active (1hr)';
      } else if (event.type == 'scroll') {
        updatedPermanentBoost = true;
        activitySubtitle = 'Permanent 1.1x XP Unlocked';
      }

      // Add to Recent Activities
      updatedActivities.insert(0, {
        'title': 'Store: ${event.title}',
        'subtitle': activitySubtitle,
        'timestamp': Timestamp.now(),
        'type': 'store',
      });
      if (updatedActivities.length > 10) updatedActivities.removeLast();

      final newHistory = _addCoinHistoryEntry(
        currentUser.coinHistory,
        title: 'Purchased ${event.title}',
        amount: -event.cost,
        isEarned: false,
      );

      final updatedUser = currentUser.copyWith(
        coins: currentUser.coins - event.cost,
        totalExp: updatedXP,
        doubleXP: updatedDoubleXP,
        doubleXPExpiry: updatedDoubleXPExpiry,
        hasPermanentXPBoost: updatedPermanentBoost,
        streakFreezes: updatedStreakFreezes,
        coinHistory: newHistory,
        recentActivities: updatedActivities,
        dailyXpHistory: updatedDailyHistory,
      );

      emit(
        AuthState.authenticated(
          updatedUser,
          message: 'Purchased!',
          lastPurchaseType: event.type,
          lastPurchaseSuccess: true,
        ),
      );
      // Reset after 1.5 seconds for UI feedback
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!isClosed) {
          add(const AuthClearPurchaseFeedback());
        }
      });

      final result = await _updateUser(UpdateUserParams(user: updatedUser));
      result.fold((failure) {
        emit(
          AuthState.authenticated(
            currentUser,
            message: 'Purchase failed on server',
          ),
        );
        emit(AuthState.authenticated(currentUser, message: null));
      }, (_) => null);
    }
  }

  void _onClearPurchaseFeedback(
    AuthClearPurchaseFeedback event,
    Emitter<AuthState> emit,
  ) {
    emit(
      AuthState._(
        status: state.status,
        user: state.user,
        message: null,
        lastPurchaseType: null,
        lastPurchaseSuccess: null,
      ),
    );
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
