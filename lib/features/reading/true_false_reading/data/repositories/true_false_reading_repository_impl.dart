import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/reading/true_false_reading/data/datasources/true_false_reading_remote_data_source.dart';
import 'package:voxai_quest/features/reading/true_false_reading/domain/entities/true_false_reading_quest.dart';
import 'package:voxai_quest/features/reading/true_false_reading/domain/repositories/true_false_reading_repository.dart';

class TrueFalseReadingRepositoryImpl implements TrueFalseReadingRepository {
  final TrueFalseReadingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TrueFalseReadingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TrueFalseReadingQuest>>>
  getTrueFalseReadingQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getTrueFalseReadingQuests(
          level,
        );
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}
