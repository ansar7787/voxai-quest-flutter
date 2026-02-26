import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/auth/data/models/user_model.dart';
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';
import 'package:voxai_quest/features/leaderboard/domain/repositories/leaderboard_repository.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final FirebaseFirestore firestore;

  LeaderboardRepositoryImpl(this.firestore);

  @override
  Future<Either<Failure, List<UserEntity>>> getTopUsers({
    int limit = 100,
  }) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .orderBy('totalExp', descending: true)
          .orderBy('coins', descending: true)
          .limit(limit)
          .get();

      final users = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();

      return Right(users);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
