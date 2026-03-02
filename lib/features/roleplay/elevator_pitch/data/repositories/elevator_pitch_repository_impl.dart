import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/roleplay/elevator_pitch/domain/entities/elevator_pitch_quest.dart';
import 'package:voxai_quest/features/roleplay/elevator_pitch/domain/repositories/elevator_pitch_repository.dart';
import 'package:voxai_quest/features/roleplay/elevator_pitch/data/datasources/elevator_pitch_remote_data_source.dart';

class ElevatorPitchRepositoryImpl implements ElevatorPitchRepository {
  final ElevatorPitchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ElevatorPitchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ElevatorPitchQuest>>> getElevatorPitchQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getElevatorPitchQuests(
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
