import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/data/datasources/reading_remote_data_source.dart';
import 'package:voxai_quest/features/reading/domain/entities/reading_quest.dart';
import 'package:voxai_quest/features/reading/domain/repositories/reading_repository.dart';

class ReadingRepositoryImpl implements ReadingRepository {
  final ReadingRemoteDataSource remoteDataSource;

  ReadingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ReadingQuest>> getReadingQuest(int difficulty) async {
    try {
      final remoteQuest = await remoteDataSource.getReadingQuest(difficulty);
      return Right(remoteQuest);
    } on ServerException {
      return Left(ServerFailure('Failed to load reading quest'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
