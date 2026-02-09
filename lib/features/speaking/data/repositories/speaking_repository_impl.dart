import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/data/datasources/speaking_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/domain/entities/speaking_quest.dart';
import 'package:voxai_quest/features/speaking/domain/repositories/speaking_repository.dart';

class SpeakingRepositoryImpl implements SpeakingRepository {
  final SpeakingRemoteDataSource remoteDataSource;

  SpeakingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SpeakingQuest>> getSpeakingQuest(
    int difficulty,
  ) async {
    try {
      final remoteQuest = await remoteDataSource.getSpeakingQuest(difficulty);
      return Right(remoteQuest);
    } on ServerException {
      return Left(ServerFailure('Failed to load speaking quest'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
