import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/writing/correction_writing/data/datasources/correction_writing_remote_data_source.dart';
import 'package:voxai_quest/features/writing/correction_writing/domain/entities/correction_writing_quest.dart';
import 'package:voxai_quest/features/writing/correction_writing/domain/repositories/correction_writing_repository.dart';

class CorrectionWritingRepositoryImpl implements CorrectionWritingRepository {
  final CorrectionWritingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CorrectionWritingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CorrectionWritingQuest>>> getCorrectionWritingQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getCorrectionWritingQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

