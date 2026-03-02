import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/roleplay/emergency_hub/domain/entities/emergency_hub_quest.dart';
import 'package:voxai_quest/features/roleplay/emergency_hub/domain/repositories/emergency_hub_repository.dart';
import 'package:voxai_quest/features/roleplay/emergency_hub/data/datasources/emergency_hub_remote_data_source.dart';

class EmergencyHubRepositoryImpl implements EmergencyHubRepository {
  final EmergencyHubRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  EmergencyHubRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<EmergencyHubQuest>>> getEmergencyHubQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getEmergencyHubQuests(
          level,
        );
        return Right(remoteQuests);
      } on ServerException {
        return Left(ServerFailure('Server error occurred'));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}
