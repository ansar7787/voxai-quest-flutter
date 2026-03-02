import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/roleplay/gourmet_order/domain/entities/gourmet_order_quest.dart';
import 'package:voxai_quest/features/roleplay/gourmet_order/domain/repositories/gourmet_order_repository.dart';
import 'package:voxai_quest/features/roleplay/gourmet_order/data/datasources/gourmet_order_remote_data_source.dart';

class GourmetOrderRepositoryImpl implements GourmetOrderRepository {
  final GourmetOrderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  GourmetOrderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<GourmetOrderQuest>>> getGourmetOrderQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getGourmetOrderQuests(level);
        return Right(remoteQuests);
      } on ServerException {
        return Left(ServerFailure('Server error occurred'));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

