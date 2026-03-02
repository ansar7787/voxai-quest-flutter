import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/listening/audio_true_false/data/datasources/audio_true_false_remote_data_source.dart';
import 'package:voxai_quest/features/listening/audio_true_false/domain/entities/audio_true_false_quest.dart';
import 'package:voxai_quest/features/listening/audio_true_false/domain/repositories/audio_true_false_repository.dart';

class AudioTrueFalseRepositoryImpl implements AudioTrueFalseRepository {
  final AudioTrueFalseRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AudioTrueFalseRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AudioTrueFalseQuest>>> getQuests(
    int level,
  ) async {
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
