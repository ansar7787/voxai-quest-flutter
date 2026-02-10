import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:voxai_quest/features/auth/data/models/user_model.dart';
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _remoteDataSource = remoteDataSource,
       _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<UserEntity?> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      try {
        final doc = await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        if (doc.exists) {
          final user = UserModel.fromMap(doc.data()!);
          // Streak Logic
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final lastLogin = user.lastLoginDate;
          final lastLoginDay = lastLogin != null
              ? DateTime(lastLogin.year, lastLogin.month, lastLogin.day)
              : null;

          if (lastLoginDay == null || lastLoginDay.isBefore(today)) {
            int newStreak = user.currentStreak;
            if (lastLoginDay != null &&
                today.difference(lastLoginDay).inDays == 1) {
              newStreak++;
            } else if (lastLoginDay != null &&
                today.difference(lastLoginDay).inDays > 1) {
              newStreak = 1;
            } else if (lastLoginDay == null) {
              newStreak = 1;
            }

            final updatedUser = user.copyWith(
              lastLoginDate: now,
              currentStreak: newStreak,
            );

            // Update FireStore
            await _firestore
                .collection('users')
                .doc(user.id)
                .update((updatedUser as UserModel).toMap());
            return updatedUser;
          }
          return user;
        } else {
          final newUser = UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            displayName: firebaseUser.displayName,
            photoUrl: firebaseUser.photoURL,
            lastLoginDate: DateTime.now(),
            currentStreak: 1,
          );
          await _firestore
              .collection('users')
              .doc(newUser.id)
              .set(newUser.toMap());
          return newUser;
        }
      } catch (e) {
        return UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName,
          photoUrl: firebaseUser.photoURL,
        );
      }
    });
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Update Display Name
        await firebaseUser.updateDisplayName(name);

        final newUser = UserModel(
          id: firebaseUser.uid,
          email: email,
          displayName: name,
          photoUrl: firebaseUser.photoURL,
          lastLoginDate: DateTime.now(),
          currentStreak: 1,
        );

        // Save to Firestore
        await _firestore
            .collection('users')
            .doc(newUser.id)
            .set(newUser.toMap());

        return Right(newUser);
      } else {
        return Left(ServerFailure('User creation failed'));
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> logInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.logInWithEmail(
        email: email,
        password: password,
      );
      return Right(userModel);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logInWithGoogle() async {
    try {
      await _remoteDataSource.logInWithGoogle();
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String _mapFirebaseError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'aborted-by-user':
        return 'Sign in was canceled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different credential.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    try {
      await _remoteDataSource.logOut();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserCoins(int newCoins) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'coins': newCoins,
        });
        return const Right(null);
      } else {
        return Left(AuthFailure('User not logged in'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategoryStats(
    String categoryId,
    bool isCorrect,
  ) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final docRef = _firestore.collection('users').doc(user.uid);
        final doc = await docRef.get();

        Map<String, int> currentStats = {};
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (data['categoryStats'] != null) {
            currentStats = Map<String, int>.from(data['categoryStats']);
          }
        }

        int currentScore = currentStats[categoryId] ?? 50;
        int newScore = isCorrect ? currentScore + 10 : currentScore - 10;
        if (newScore > 100) newScore = 100;
        if (newScore < 0) newScore = 0;

        currentStats[categoryId] = newScore;

        await docRef.update({'categoryStats': currentStats});
        return const Right(null);
      } else {
        return Left(AuthFailure('User not logged in'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> awardBadge(String badgeId) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'badges': FieldValue.arrayUnion([badgeId]),
        });
      }
    } catch (e) {
      // Log error or handle as needed
    }
  }
}
