import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/kids_zone/data/datasources/kids_remote_data_source.dart';
import 'package:voxai_quest/features/kids_zone/domain/entities/kids_quest.dart';
import 'package:voxai_quest/features/kids_zone/domain/repositories/kids_repository.dart';

class KidsRepositoryImpl implements KidsRepository {
  final KidsRemoteDataSource remoteDataSource;

  KidsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<KidsQuest>>> getQuestsByLevel(
    String gameType,
    int level,
  ) async {
    try {
      final quests = await remoteDataSource.getQuestsByLevel(gameType, level);
      return Right(quests);
    } catch (e) {
      return const Left(ServerFailure('Firestore data error'));
    }
  }
}
