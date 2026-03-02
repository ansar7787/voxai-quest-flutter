import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/speaking/daily_expression/data/datasources/daily_expression_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/daily_expression/domain/entities/daily_expression_quest.dart';
import 'package:voxai_quest/features/speaking/daily_expression/domain/repositories/daily_expression_repository.dart';

class DailyExpressionRepositoryImpl implements DailyExpressionRepository {
  final DailyExpressionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DailyExpressionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DailyExpressionQuest>>> getDailyExpressionQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getDailyExpressionQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

