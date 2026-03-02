import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/writing/describe_situation_writing/data/datasources/describe_situation_writing_remote_data_source.dart';
import 'package:voxai_quest/features/writing/describe_situation_writing/domain/entities/describe_situation_writing_quest.dart';
import 'package:voxai_quest/features/writing/describe_situation_writing/domain/repositories/describe_situation_writing_repository.dart';

class DescribeSituationWritingRepositoryImpl
    implements DescribeSituationWritingRepository {
  final DescribeSituationWritingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DescribeSituationWritingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DescribeSituationWritingQuest>>>
  getDescribeSituationWritingQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource
            .getDescribeSituationWritingQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}
