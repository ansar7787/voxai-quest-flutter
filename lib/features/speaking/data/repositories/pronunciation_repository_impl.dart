import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/speaking/data/datasources/pronunciation_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/domain/entities/pronunciation_quest.dart';
import 'package:voxai_quest/features/speaking/domain/repositories/pronunciation_repository.dart';

class PronunciationRepositoryImpl implements PronunciationRepository {
  final PronunciationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PronunciationRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PronunciationQuest>> getPronunciationQuest(
    int difficulty,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuest = await remoteDataSource.getPronunciationQuest(
          difficulty,
        );
        return Right(remoteQuest);
      } on ServerException {
        return Left(ServerFailure('Failed to load pronunciation quest'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(ServerFailure('No internet connection'));
    }
  }
}
