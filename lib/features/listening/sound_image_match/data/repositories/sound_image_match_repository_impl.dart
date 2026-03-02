import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/listening/sound_image_match/data/datasources/sound_image_match_remote_data_source.dart';
import 'package:voxai_quest/features/listening/sound_image_match/domain/entities/sound_image_match_quest.dart';
import 'package:voxai_quest/features/listening/sound_image_match/domain/repositories/sound_image_match_repository.dart';

class SoundImageMatchRepositoryImpl implements SoundImageMatchRepository {
  final SoundImageMatchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SoundImageMatchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SoundImageMatchQuest>>> getQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }
}
