import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:voxai_quest/features/auth/data/models/user_model.dart';
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _remoteDataSource = remoteDataSource,
       _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance;

  @override
  Stream<UserEntity?> get user {
    return _firebaseAuth.userChanges().asyncExpand((firebaseUser) {
      if (firebaseUser == null) {
        return Stream.value(null);
      }
      return _firestore.collection('users').doc(firebaseUser.uid).snapshots().map((
        doc,
      ) {
        try {
          if (doc.exists && doc.data() != null) {
            final userModel = UserModel.fromMap(doc.data()!);
            // Keep Auth-managed fields in sync if needed
            return userModel.copyWith(
              isEmailVerified: firebaseUser.emailVerified,
            );
          } else {
            // Fallback if doc doesn't exist yet (rare race condition or new user)
            return UserModel(
              id: firebaseUser.uid,
              email: firebaseUser.email ?? '',
              displayName: firebaseUser.displayName,
              photoUrl: firebaseUser.photoURL,
              isEmailVerified: firebaseUser.emailVerified,
              dailyXpHistory: const {},
              recentActivities: const [],
            );
          }
        } catch (e, stack) {
          debugPrint('Error in AuthRepository.user stream mapping: $e');
          debugPrint(stack.toString());
          // We could return null here, but the stream is Stream<UserEntity?>.
          // Returning null might log the user out if AuthBloc emits it.
          // For now, let's at least not crash the stream.
          return null;
        }
      });
    });
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      final user = await _mapFirebaseUserToUserEntity(firebaseUser);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<UserEntity?> _mapFirebaseUserToUserEntity(
    firebase_auth.User? firebaseUser,
  ) async {
    if (firebaseUser == null) return null;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      if (doc.exists) {
        final user = UserModel.fromMap(doc.data()!);
        return user.copyWith(isEmailVerified: firebaseUser.emailVerified);
      } else {
        final newUser = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName,
          photoUrl: firebaseUser.photoURL,
          lastLoginDate: DateTime.now(),
          currentStreak: 1,
          isEmailVerified: firebaseUser.emailVerified,
          dailyXpHistory: const {},
          recentActivities: const [],
        );
        await _firestore
            .collection('users')
            .doc(newUser.id)
            .set(newUser.toMap());
        return newUser;
      }
    } catch (e, stack) {
      debugPrint('Error in _mapFirebaseUserToUserEntity: $e');
      debugPrint(stack.toString());
      return null;
    }
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
          dailyXpHistory: const {},
          recentActivities: const [],
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
      return Left(AuthFailure(e.code));
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
      return Left(AuthFailure(e.code));
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
      return Left(AuthFailure(e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
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
      return Left(AuthFailure(e.code));
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
      return Left(AuthFailure(e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserCoins(
    int amountChange, {
    String? title,
    bool? isEarned,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final docRef = _firestore.collection('users').doc(user.uid);

        if (title != null) {
          final doc = await docRef.get();
          if (doc.exists && doc.data() != null) {
            final data = doc.data()!;
            List<Map<String, dynamic>> history = [];
            if (data['coinHistory'] != null) {
              history = List<Map<String, dynamic>>.from(data['coinHistory']);
            }

            final entry = {
              'title': title,
              'amount': amountChange,
              'isEarned': isEarned ?? (amountChange > 0),
              'date': DateTime.now().toIso8601String(),
            };

            history.insert(0, entry);
            if (history.length > 10) history.removeLast();

            await docRef.update({
              'coins': FieldValue.increment(amountChange),
              'coinHistory': history,
            });
            return const Right(null);
          }
        }

        // Fallback for simple increment without history
        await docRef.update({'coins': FieldValue.increment(amountChange)});
        return const Right(null);
      } else {
        return Left(AuthFailure('User not logged in'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserRewards({
    required String gameType,
    required int level,
    required int xpIncrease,
    required int coinIncrease,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final docRef = _firestore.collection('users').doc(user.uid);
        final doc = await docRef.get();

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          Map<String, int> dailyHistory = {};
          List<Map<String, dynamic>> activities = [];
          Map<String, List<int>> completedLevels = {};
          Map<String, int> unlockedLevels = {};

          if (data['dailyXpHistory'] != null) {
            dailyHistory = Map<String, int>.from(data['dailyXpHistory']);
          }
          if (data['recentActivities'] != null) {
            activities = List<Map<String, dynamic>>.from(
              data['recentActivities'],
            );
          }
          if (data['completedLevels'] != null) {
            completedLevels = (data['completedLevels'] as Map<String, dynamic>)
                .map((key, value) => MapEntry(key, List<int>.from(value)));
          }
          if (data['unlockedLevels'] != null) {
            unlockedLevels = Map<String, int>.from(data['unlockedLevels']);
          }

          // Deduplication Check
          final categoryCompleted = completedLevels[gameType] ?? [];
          if (categoryCompleted.contains(level)) {
            return const Right(null); // Already rewarded
          }

          // Apply Multipliers
          double xpMultiplier = 1.0;
          if (data['hasPermanentXPBoost'] == true) xpMultiplier *= 1.1;

          final doubleXPExpiry = data['doubleXPExpiry'] != null
              ? (data['doubleXPExpiry'] as Timestamp).toDate()
              : null;
          if (doubleXPExpiry != null &&
              doubleXPExpiry.isAfter(DateTime.now())) {
            xpMultiplier *= 2.0;
          }

          final finalXpIncrease = (xpIncrease * xpMultiplier).round();

          // Mark as Completed
          categoryCompleted.add(level);
          completedLevels[gameType] = categoryCompleted;

          // Update Daily XP
          final now = DateTime.now();
          final todayKey =
              "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
          final currentDaily = dailyHistory[todayKey] ?? 0;
          dailyHistory[todayKey] = currentDaily + finalXpIncrease;

          // Add Activity
          final newActivity = {
            'title': 'Quest Completed',
            'subtitle': '+$finalXpIncrease XP · +$coinIncrease Coins',
            'timestamp': Timestamp.now(),
            'type': 'quest',
          };
          activities.insert(0, newActivity);
          if (activities.length > 10) {
            activities = activities.sublist(0, 10);
          }

          // Apply Multiplier for Premium Users or Level 100+
          int finalCoinIncrease = coinIncrease;
          final userExp = data['totalExp'] as int? ?? 0;
          final userLevel = (userExp / 100).floor() + 1;

          if (data['isPremium'] == true || userLevel >= 100) {
            finalCoinIncrease = coinIncrease * 2;
          }

          // Detect if it's a Kids Zone game to update kidsCoins
          final kidsGames = {
            'alphabet',
            'numbers',
            'colors',
            'shapes',
            'animals',
            'fruits',
            'family',
            'school',
            'verbs',
            'routine',
            'emotions',
            'prepositions',
            'phonics',
            'day_night',
            'nature',
            'home_kids',
            'food_kids',
            'transport',
            'time',
            'opposites',
          };
          final isKidsGame = kidsGames.contains(gameType);

          // Unlock next level if applicable
          final currentUnlocked = unlockedLevels[gameType] ?? 1;
          if (level >= currentUnlocked) {
            unlockedLevels[gameType] = level + 1;
          }

          // Update history list
          List<Map<String, dynamic>> history = [];
          if (data['coinHistory'] != null) {
            history = List<Map<String, dynamic>>.from(data['coinHistory']);
          }

          final entry = {
            'title': 'Quest Reward - ${gameType.toUpperCase()}',
            'amount': finalCoinIncrease,
            'isEarned': true,
            'date': DateTime.now().toIso8601String(),
          };

          history.insert(0, entry);
          if (history.length > 10) history.removeLast();

          await docRef.update({
            'totalExp': FieldValue.increment(finalXpIncrease),
            isKidsGame ? 'kidsCoins' : 'coins': FieldValue.increment(
              finalCoinIncrease,
            ),
            'coinHistory': history,
            'dailyXpHistory': dailyHistory,
            'recentActivities': activities,
            'completedLevels': completedLevels,
            'unlockedLevels': unlockedLevels,
          });
        }
        return const Right(null);
      } else {
        return Left(AuthFailure('User not logged in'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> useHint() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final docRef = _firestore.collection('users').doc(user.uid);
        final doc = await docRef.get();
        if (doc.exists && doc.data() != null) {
          final hintCount = doc.data()?['hintCount'] ?? 0;
          if (hintCount > 0) {
            await docRef.update({'hintCount': FieldValue.increment(-1)});
            return const Right(null);
          } else {
            return Left(ServerFailure('No hints available'));
          }
        }
        return Left(ServerFailure('User data not found'));
      }
      return Left(AuthFailure('User not logged in'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> purchaseHint(int cost, int hintAmount) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final docRef = _firestore.collection('users').doc(user.uid);
        final doc = await docRef.get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          final coins = data['coins'] ?? 0;
          if (coins >= cost) {
            // Update history list
            List<Map<String, dynamic>> history = [];
            if (data['coinHistory'] != null) {
              history = List<Map<String, dynamic>>.from(data['coinHistory']);
            }

            final entry = {
              'title': 'Purchased Hint Pack',
              'amount': -cost,
              'isEarned': false,
              'date': DateTime.now().toIso8601String(),
            };

            history.insert(0, entry);
            if (history.length > 10) history.removeLast();

            await docRef.update({
              'coins': FieldValue.increment(-cost),
              'hintCount': FieldValue.increment(hintAmount),
              'coinHistory': history,
            });
            return const Right(null);
          } else {
            return Left(ServerFailure('Not enough coins'));
          }
        }
        return Left(ServerFailure('User data not found'));
      }
      return Left(AuthFailure('User not logged in'));
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
  Future<Either<Failure, void>> updateUnlockedLevel(
    String categoryId,
    int newLevel,
  ) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final docRef = _firestore.collection('users').doc(user.uid);
        final doc = await docRef.get();

        Map<String, int> unlockedLevels = {};
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (data['unlockedLevels'] != null) {
            unlockedLevels = Map<String, int>.from(data['unlockedLevels']);
          }
        }

        final currentUnlocked = unlockedLevels[categoryId] ?? 1;
        if (newLevel > currentUnlocked) {
          unlockedLevels[categoryId] = newLevel;
          await docRef.update({'unlockedLevels': unlockedLevels});
        }
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

  @override
  Future<Either<Failure, void>> reloadUser() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(UserEntity user) async {
    try {
      final docRef = _firestore.collection('users').doc(user.id);
      final userModel = UserModel(
        id: user.id,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
        coins: user.coins,
        totalExp: user.totalExp,
        isAdmin: user.isAdmin,
        currentStreak: user.currentStreak,
        lastLoginDate: user.lastLoginDate,
        isEmailVerified: user.isEmailVerified,
        isPremium: user.isPremium,
        premiumExpiryDate: user.premiumExpiryDate,
        categoryStats: user.categoryStats,
        unlockedLevels: user.unlockedLevels,
        badges: user.badges,
        streakFreezes: user.streakFreezes,
        hintCount: user.hintCount,
        hintPacks: user.hintPacks,
        doubleXP: user.doubleXP,
        doubleXPExpiry: user.doubleXPExpiry,
        dailyXpHistory: user.dailyXpHistory,
        recentActivities: user.recentActivities,
        completedLevels: user.completedLevels,
        lastVipGiftDate: user.lastVipGiftDate,
        lastDailyRewardDate: user.lastDailyRewardDate,
        kidsCoins: user.kidsCoins,
        kidsStickers: user.kidsStickers,
        kidsMascot: user.kidsMascot,
        kidsEquippedSticker: user.kidsEquippedSticker,
        kidsOwnedAccessories: user.kidsOwnedAccessories,
        kidsEquippedAccessory: user.kidsEquippedAccessory,
      );

      await docRef.update(userModel.toMap());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> claimVipGift() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final docRef = _firestore.collection('users').doc(user.uid);
        final doc = await docRef.get();

        if (doc.exists && doc.data() != null) {
          final userData = UserModel.fromMap(doc.data()!);

          if (!userData.isPremium) {
            return Left(AuthFailure('User is not premium'));
          }

          if (!userData.isVipGiftAvailable) {
            return Left(AuthFailure('VIP gift already claimed today'));
          }

          final updatedUser = userData.copyWith(
            coins: userData.coins + 100,
            lastVipGiftDate: DateTime.now(),
          );

          await docRef.update(updatedUser.toMap());
          return const Right(null);
        }
        return Left(AuthFailure('User data not found'));
      } else {
        return Left(AuthFailure('User not logged in'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateProfilePicture(String filePath) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return Left(ServerFailure('User not authenticated'));

      final file = File(filePath);
      final ref = _storage.ref().child('profile_pics').child('${user.uid}.jpg');

      // Upload file
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();

      // Update Firebase Auth
      await user.updatePhotoURL(downloadUrl);

      // Update Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'photoUrl': downloadUrl,
      });

      return Right(downloadUrl);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDisplayName(String displayName) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return Left(ServerFailure('User not authenticated'));

      // Update Firebase Auth
      await user.updateDisplayName(displayName);

      // Update Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'displayName': displayName,
      });

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> awardKidsSticker(String stickerId) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'kidsStickers': FieldValue.arrayUnion([stickerId]),
        });
        return const Right(null);
      }
      return Left(AuthFailure('User not logged in'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateKidsMascot(String mascotId) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'kidsMascot': mascotId,
        });
        return const Right(null);
      }
      return Left(AuthFailure('User not logged in'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> buyKidsAccessory(
    String accessoryId,
    int cost,
  ) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final docRef = _firestore.collection('users').doc(user.uid);
        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(docRef);
          if (!snapshot.exists) throw Exception("User not found");

          final data = snapshot.data()!;
          final currentCoins = (data['kidsCoins'] as num?)?.toInt() ?? 0;
          final owned = List<String>.from(data['kidsOwnedAccessories'] ?? []);

          if (owned.contains(accessoryId)) {
            // Already owned, skip
            return;
          }

          if (currentCoins < cost) {
            throw Exception("Not enough Kids Coins");
          }

          transaction.update(docRef, {
            'kidsCoins': currentCoins - cost,
            'kidsOwnedAccessories': FieldValue.arrayUnion([accessoryId]),
          });
        });
        return const Right(null);
      }
      return Left(AuthFailure('User not logged in'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> equipKidsAccessory(String? accessoryId) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'kidsEquippedAccessory': accessoryId,
        });
        return const Right(null);
      }
      return Left(AuthFailure('User not logged in'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> repairStreak(int cost) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final docRef = _firestore.collection('users').doc(user.uid);
        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(docRef);
          if (!snapshot.exists) throw Exception("User not found");
          final currentCoins =
              (snapshot.data()?['coins'] as num?)?.toInt() ?? 0;
          if (currentCoins < cost) throw Exception("Not enough coins");

          // To repair, we simply set currentStreak back to something meaningful?
          // Actually, the repair happens when they miss a day.
          // For now, let's assume repair sets currentStreak to lastStreak + 1 or similar.
          // But we don't store lastStreak.
          // Simplest repair: If streak is 1 (just reset), set it to something higher?
          // Better logic: The caller provides the new streak value or we just increment it.
          // Let's just deduct coins and let the Bloc handle the entity state update if possible,
          // OR we can do it here if we have enough info.
          // Since we are in a transaction, let's just do the coin deduction and the caller will update the entity.
          // Actually, if we want it to be atomic:
          final history = List<Map<String, dynamic>>.from(
            snapshot.data()?['coinHistory'] ?? [],
          );
          final entry = {
            'title': 'Repaired Streak',
            'amount': -cost,
            'isEarned': false,
            'date': DateTime.now().toIso8601String(),
          };
          history.insert(0, entry);
          if (history.length > 10) history.removeLast();

          transaction.update(docRef, {
            'coins': currentCoins - cost,
            'coinHistory': history,
            // Logic for repair: if they just reset to 1 today, maybe we cannot know what it was.
            // But usually, repair is called immediately after a reset.
          });
        });
        return const Right(null);
      }
      return Left(AuthFailure('User not logged in'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> purchaseStreakFreeze(int cost) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final docRef = _firestore.collection('users').doc(user.uid);
        final doc = await docRef.get();

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          List<Map<String, dynamic>> history = [];
          if (data['coinHistory'] != null) {
            history = List<Map<String, dynamic>>.from(data['coinHistory']);
          }

          final entry = {
            'title': 'Purchased Streak Freeze',
            'amount': -cost,
            'isEarned': false,
            'date': DateTime.now().toIso8601String(),
          };

          history.insert(0, entry);
          if (history.length > 10) history.removeLast();

          await docRef.update({
            'coins': FieldValue.increment(-cost),
            'streakFreezes': FieldValue.increment(1),
            'coinHistory': history,
          });
          return const Right(null);
        }
        return Left(ServerFailure('User data not found'));
      }
      return Left(AuthFailure('User not logged in'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> activateDoubleXP(int cost) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final docRef = _firestore.collection('users').doc(user.uid);
        final doc = await docRef.get();

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          List<Map<String, dynamic>> history = [];
          if (data['coinHistory'] != null) {
            history = List<Map<String, dynamic>>.from(data['coinHistory']);
          }

          final entry = {
            'title': 'Purchased Double XP',
            'amount': -cost,
            'isEarned': false,
            'date': DateTime.now().toIso8601String(),
          };

          history.insert(0, entry);
          if (history.length > 10) history.removeLast();

          final expiry = DateTime.now().add(const Duration(hours: 24));
          await docRef.update({
            'coins': FieldValue.increment(-cost),
            'doubleXP': 1,
            'doubleXPExpiry': Timestamp.fromDate(expiry),
            'coinHistory': history,
          });
          return const Right(null);
        }
        return Left(ServerFailure('User data not found'));
      }
      return Left(AuthFailure('User not logged in'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final uid = user.uid;
        // 1. Delete Firestore document
        await _firestore.collection('users').doc(uid).delete();
        // 2. Delete Firebase Auth user
        await user.delete();
        return const Right(null);
      }
      return Left(AuthFailure('User not logged in'));
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return Left(AuthFailure('requires-recent-login'));
      }
      return Left(AuthFailure(e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
