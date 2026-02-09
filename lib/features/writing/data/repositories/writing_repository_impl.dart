import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/data/datasources/writing_remote_data_source.dart';
import 'package:voxai_quest/features/writing/domain/entities/writing_quest.dart';
import 'package:voxai_quest/features/writing/domain/repositories/writing_repository.dart';

class WritingRepositoryImpl implements WritingRepository {
  final WritingRemoteDataSource remoteDataSource;

  WritingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WritingQuest>> getWritingQuest(int difficulty) async {
    try {
      final remoteQuest = await remoteDataSource.getWritingQuest(difficulty);
      return Right(remoteQuest);
    } on ServerException {
      return Left(ServerFailure('Failed to load writing quest'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
