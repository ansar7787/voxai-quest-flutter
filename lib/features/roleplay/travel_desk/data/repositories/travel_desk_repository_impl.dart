import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/roleplay/travel_desk/domain/entities/travel_desk_quest.dart';
import 'package:voxai_quest/features/roleplay/travel_desk/domain/repositories/travel_desk_repository.dart';
import 'package:voxai_quest/features/roleplay/travel_desk/data/datasources/travel_desk_remote_data_source.dart';

class TravelDeskRepositoryImpl implements TravelDeskRepository {
  final TravelDeskRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TravelDeskRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TravelDeskQuest>>> getTravelDeskQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getTravelDeskQuests(level);
        return Right(remoteQuests);
      } on ServerException {
        return Left(ServerFailure('Server error occurred'));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}
